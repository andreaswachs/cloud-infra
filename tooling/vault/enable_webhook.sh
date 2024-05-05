#!/bin/bash

should_close_portforward=false

# If nothing is listening on port 8200, port-forward the vault service
if ! nc -z localhost 8200; then
    kubectl port-forward svc/vault 8200:8200 -n vault &
    should_close_portforward=true
fi


export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=$(read -sp "Enter the root token for the vault: " token && echo $token)

# Create a shorthand for executing vault commands in the vault pod
vault="vault"

# Get some information about the cluster
TOKEN_REVIEW_JWT=$(kubectl get secret vault-auth -n vault -o go-template='{{ .data.token }}' | base64 --decode)
KUBE_CA_CERT=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)
KUBE_HOST="https://kubernetes.default.svc"

# Prepare Vault by enabling kubernetes auth
$vault auth enable kubernetes

# Configure the kubernets authentication method with the vault SA token, internal kubernetes API and the cluster cert
$vault write auth/kubernetes/config \
  token_reviewer_jwt="$TOKEN_REVIEW_JWT" \
  kubernetes_host="$KUBE_HOST" \
  kubernetes_ca_cert="$KUBE_CA_CERT" \
  disable_local_ca_jwt="true" \
  disable_iss_validation="true"

# Create a Terraform policy for a terraform role
# should allow all access to secrets KV engines
# The policy should not be bound to any Terraform role -
# we create tokens for it for CI/CD pipeline use
$vault policy write terraform - <<EOF
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF


# Create vault KV2 engine for "default" secrets
$vault secrets enable -path=default -version=2 kv
$vault kv put default/validate foo=bar

# Create a policy for the default role
# The policy should allow for all actiosn within the default secret engine
$vault policy write default - <<EOF
path "default/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

# Create a role for the default policy
$vault write auth/kubernetes/role/default \
  bound_service_account_names=default \
  bound_service_account_namespaces=* \
  policies=default \
  ttl=1h

if [ $should_close_portforward = 'true' ]; then
    echo "Closing port-forward"
    pkill -f "kubectl port-forward svc/vault 8200:8200 -n vault"
fi
