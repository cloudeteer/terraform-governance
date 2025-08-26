# How to import a state:
# 1. add topics "terraform-module,auto-terraform-governance" to repository
# 2. add collaborator "cloudeteerbot" with admin permission to repository
# 3. add import entry for repository here
# 4. commit and run module-repo-setup action

import {
  id = "terraform-azurerm-helloworld"
  to = module.github_repository["terraform-azurerm-helloworld"].github_repository.repository
}

import {
  id = "terraform-azurerm-mssql-vm"
  to = module.github_repository["terraform-azurerm-mssql-vm"].github_repository.repository
}

# fresh import of terraform-azurerm-avd
import {
  id = "terraform-azurerm-avd"
  to = module.github_repository["terraform-azurerm-avd"].github_repository.repository
}

# Move and import presotiroy which has been renamed from ai-foundry-hub to ai-stack
moved {
  from = module.github_repository["terraform-azurerm-azure-ai-foundry-hub"].github_repository.repository
  to   = module.github_repository["terraform-azurerm-ai-stack"].github_repository.repository
}
import {
  id = "terraform-azurerm-ai-stack"
  to = module.github_repository["terraform-azurerm-ai-stack"].github_repository.repository
}

# Import for manually created repository of the vsoc-core module
import {
  id = "terraform-azurerm-vsoc-core"
  to = module.github_repository["terraform-azurerm-vsoc-core"].github_repository.repository
}
