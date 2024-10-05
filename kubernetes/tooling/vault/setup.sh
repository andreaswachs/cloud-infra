#!/bin/bash


# Remember to save the keys!!!
# This should be ran immediately after deploying Vault
kubectl exec --stdin=true --tty=true vault-0 -n vault -- vault operator init  --namespace='vault' | tee ~/vault_keys.txt
