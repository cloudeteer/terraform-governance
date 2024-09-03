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
