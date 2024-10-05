#!/bin/bash

export VAULT_ADDR=https://vault.wachs.work
export VAULT_TOKEN=$(read -sp "Enter the root token for the vault: " token && echo $token)

export auth0_base_url_full="wachs.eu.auth0.com"
export auth0_client_id="vbhf8DHKKiURoXYdKqfxY6eX8KbXxFTJ"
export auth0_client_secret=$(read -sp "Enter the client secret for the Auth0 application: " client_secret && echo $client_secret)

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

$vault auth enable oidc
$vault write auth/oidc/config \
  oidc_discovery_url="${auth0_base_url_full}" \
  oidc_client_id="${auth0_client_id}" \
  oidc_client_secret="${auth0_client_secret}" \
  bound_issuer="${auth0_base_url_full}" \
  tune/listing_visibility=unauth \
  default_role=admi
