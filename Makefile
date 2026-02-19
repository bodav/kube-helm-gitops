.PHONY: help diff apply sync destroy list status template install-deps validate

help: ## Show this help message
	@echo "Helmfile Management Commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

validate: ## Validate helmfile configuration and prerequisites
	@./validate.sh

install-deps: ## Install helmfile (Linux)
	@echo "Installing helmfile..."
	@curl -LO https://github.com/helmfile/helmfile/releases/latest/download/helmfile_linux_amd64
	@chmod +x helmfile_linux_amd64
	@sudo mv helmfile_linux_amd64 /usr/local/bin/helmfile
	@helmfile --version

diff: ## Show what changes would be applied
	helmfile diff

apply: ## Deploy all applications (safe, with diff)
	helmfile apply

sync: ## Deploy all applications (fast, no diff)
	helmfile sync

destroy: ## Remove all applications
	@echo "WARNING: This will remove all applications!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		helmfile destroy; \
	fi

list: ## List all configured releases
	helmfile list

status: ## Show status of all releases
	helmfile status

template: ## Generate manifests without applying
	helmfile template

# Selective deployments
deploy-system: ## Deploy only system components
	helmfile -l tier=system apply

deploy-media: ## Deploy only media apps (jellyfin, metube, filebrowser)
	helmfile -l category=media apply

deploy-tools: ## Deploy only tool apps (gotify, whoami)
	helmfile -l tier=apps -l category!=media apply

# Individual apps
deploy-jellyfin: ## Deploy jellyfin only
	helmfile -l name=jellyfin apply

deploy-metube: ## Deploy metube only
	helmfile -l name=metube apply

deploy-filebrowser: ## Deploy filebrowser only
	helmfile -l name=filebrowser apply

deploy-gotify: ## Deploy gotify only
	helmfile -l name=gotify apply

deploy-whoami: ## Deploy whoami only
	helmfile -l name=whoami apply

# Cleanup
clean-media: ## Remove all media apps
	helmfile -l category=media destroy

clean-tools: ## Remove all tool apps
	helmfile -l tier=apps -l category!=media destroy
