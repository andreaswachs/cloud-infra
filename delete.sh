#/bin/bash

# Uninstall Helm packages
helm uninstall wachswork
helm uninstall cert-manager -n cert-manager

# Manually remove resourecs that were 'directly' applied
kubectl delete -f cluster/issuers.yaml
