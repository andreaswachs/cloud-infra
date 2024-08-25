#!/bin/bash

IP="100.42.188.3"
USER="host"

k3sup install --ip $IP --user host --k3s-extra-args '--disable traefik'



# helm repo add jetstack https://charts.jetstack.io
# helm repo update
# 
# helm upgrade \
#   cert-manager jetstack/cert-manager \
#   --install --atomic --wait --timeout=5m \
#   --namespace cert-manager \
#   --create-namespace \
#   --version v1.12.2 \
#   --set installCRDs=true
# 
# kubectl apply -f cluster/issuers.yaml

# Setting up local storage
#cat << EOF | kubectl apply -f -
# kind: StorageClass
# apiVersion: storage.k8s.io/v1
# metadata:
#   name: local-storage
# provisioner: kubernetes.io/no-provisioner
# volumeBindingMode: WaitForFirstConsumer
# EOF
