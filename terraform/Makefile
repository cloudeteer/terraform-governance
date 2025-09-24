##
# Console Colors
##
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

# Parse subscription from Terraform file
SUBSCRIPTION_FILE := module-repo-setup.tf
# Name of the env cache file
AZURE_ENV := .azure-env
TENV_DEFAULT_TOFU := true

##
# Targets
##
.PHONY: help
help: ## show this help.
	@echo 'Usage:'
	@echo '  ${GREEN}make${RESET} ${YELLOW}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "  ${GREEN}%-21s${YELLOW}%s${RESET}\n", $$1, $$2} \
		else if (/^## .*$$/) {printf "  ${CYAN}%s${RESET}\n", substr($$1,4)} \
		}' $(MAKEFILE_LIST)

.PHONY: create_terraform_state_container
create_terraform_state_container: ## create storage account container for terraform state
	export SUBSCRIPTION_ID=a78e11bf-66d8-4aae-b171-cc43ced4e6ca && \
	export RESOURCE_GROUP_NAME=rg-terraform-governance && \
	export STORAGE_ACCOUNT_NAME=sttfgovernancestate && \
	echo 'Setup Storage Account for Terraform' && \
    az storage account create -o table --resource-group "$$RESOURCE_GROUP_NAME" --name "$$STORAGE_ACCOUNT_NAME" --sku Standard_ZRS --encryption-services blob --subscription $$SUBSCRIPTION_ID && \
	echo 'Setup Storage Container for Terraform in subscription: CDT Sponsored Gold OE-CHAPTER' && \
	az storage container create -o table --name terraform-governance --account-name $$STORAGE_ACCOUNT_NAME --subscription $$SUBSCRIPTION_ID

.PHONY: init
init: ## Initialize the directory only where the command is being used.
	tenv tofu detect
	tofu init

.PHONY: upgrade
upgrade: ## Upgrade the tofu dependencies
	tofu init -upgrade

.PHONY: unlock
unlock: ## Unlock the state file
	@printf "Enter LOCK ID: "; read LOCK_ID; \
	tofu force-unlock -force $$LOCK_ID

.PHONY: validate
validate: ## Validate tofu files
	@tofu validate

.PHONY: azure_env
azure_env: ## Generate .azure-env with Azure credentials if it doesn't exist
	@if [ ! -f $(AZURE_ENV) ]; then \
		echo "[+] Generating $(AZURE_ENV)..." && \
		echo "export TF_VAR_ARM_SUBSCRIPTION_ID=$$(sed -n 's/.*subscription_id *= *\"\(.*\)\".*/\1/p' $(SUBSCRIPTION_FILE))" >> $(AZURE_ENV) && \
		echo "export TF_VAR_ARM_CLIENT_ID=$$(az account show --query user.name -o tsv)" >> $(AZURE_ENV) && \
		echo "export TF_VAR_ARM_TENANT_ID=$$(az account show --query tenantId -o tsv)" >> $(AZURE_ENV); \
	else \
		echo "[✓] $(AZURE_ENV) already exists."; \
	fi

.PHONY: plan
plan: azure_env ## Run tofu plan
	@. $(AZURE_ENV) && tofu plan

.PHONY: plan-refresh
plan-refresh: azure_env ## Run tofu plan with refresh-only
	@. $(AZURE_ENV) && tofu plan -refresh-only

.PHONY: console
console: ## Run tofu console. You may run "make plan-refresh" before.
	@tofu console

.PHONY: apply
apply: azure_env ## Run tofu apply
	@. $(AZURE_ENV) && tofu apply

.PHONY: destroy
destroy: azure_env ## Run tofu destroy
	@. $(AZURE_ENV) && tofu destroy
