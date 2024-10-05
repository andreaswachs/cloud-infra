.PHONY: sync-all
sync-all:
	helmfile sync --environment=np
	helmfile sync --environment=prod

.PHONY: sync-np
sync-np:
	helmfile sync --environment=np

.PHONY: sync-prod
sync-prod:
	helmfile sync --environment=prod
