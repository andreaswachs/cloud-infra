ENVIRONMENT ?= np

.PHONYL sync-all
sync-all:
	helmfile sync --environment=$(ENVIRONMENT)

.PHONY: sync-chatgpt
sync-chatgpt:
	cd chatgpt && \
	helmfile sync --environment=$(ENVIRONMENT) && \
	cd ..

