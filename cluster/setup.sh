#!/bin/bash

helm repo add jetstack https://charts.jetstack.io
helm repo add couchdb https://apache.github.io/couchdb-helm
helm repo update

helm upgrade \
  cert-manager jetstack/cert-manager \
  --install --atomic --wait --timeout=5m \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.2 \
  --set installCRDs=true

kubectl apply -f cluster/issuers.yaml

# Setting up local storage
cat << EOF | kubectl apply -f -
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
EOF

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: local-pv
spec:
  capacity:
    storage: 100Gi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: local-storage
  local:
    path: /home/ubuntu/volumes/pv1
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - vmi1371041.contaboserver.net
EOF
