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
	echo 'Setup Storage Container for Terraform in stcdtoetfstate subscription: CDT Sponsored Gold OE-CHAPTER' && \
	SUBSCRIPTION_ID=a78e11bf-66d8-4aae-b171-cc43ced4e6ca az storage container create -o table --name terraform-governance --account-name stcdtoetfstate --subscription $$SUBSCRIPTION_ID

.PHONY: init
init: ## Initialize the directory only where the command is being used.
	tenv tofu detect
	tofu init

.PHONY: validate
validate: ## Validate terragrunt files + terraform level modules
	tofu validate

.PHONY: plan
plan: ## run terragrunt plan for all levels
	tofu plan

.PHONY: apply
apply: ## run terragrunt apply for all levels
	tofu apply

.PHONY: destroy
destroy: ## run terragrunt destroy for all levels
	tofu destroy

.PHONY: importRepo
importRepo: ## Import the repository into the Azure DevOps
	tofu import 'module.github_repository["terraform-test-autocreated1"].github_repository.repository' terraform-test-autocreated1
	tofu import 'module.github_repository["terraform-test-autocreated1"].github_branch.branch_main' terraform-test-autocreated1:main
	tofu import 'module.github_repository["terraform-test-autocreated1"].github_branch_default.branch_default' terraform-test-autocreated1
