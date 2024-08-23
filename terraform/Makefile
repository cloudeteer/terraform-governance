##
# Console Colors
##
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

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

.PHONY: create-terraform-state-container
create-terraform-state-container: ## create storage account container for terraform state
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

.PHONY: unlock
unlock: ## Unlock the state file
	@printf "Enter LOCK ID: "; read LOCK_ID; \
	tofu force-unlock -force $$LOCK_ID

.PHONY: validate
validate: ## Validate terragrunt files + terraform level modules
	@tofu validate

.PHONY: plan
plan: ## run terragrunt plan for all levels
	@ARM_SUBSCRIPTION_ID=a78e11bf-66d8-4aae-b171-cc43ced4e6ca \
	tofu plan

.PHONY: apply
apply: ## run terragrunt apply for all levels
	@ARM_SUBSCRIPTION_ID=a78e11bf-66d8-4aae-b171-cc43ced4e6ca \
	tofu apply

.PHONY: destroy
destroy: ## run terragrunt destroy for all levels
	@tofu destroy
