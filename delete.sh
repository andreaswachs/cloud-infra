#/bin/bash

# Uninstall Helm packages
helm uninstall blog
helm uninstall cert-manager -n cert-manager

# Manually remove resourecs that were 'directly' applied
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.crds.yaml
kubectl delete -f cluster/issuers.yaml
kubectl delete -f cluster/traefik-middleware.yaml
