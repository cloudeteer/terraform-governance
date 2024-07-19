terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-governance"
    storage_account_name = "sttfgovernancestate"
    container_name       = "terraform-governance"
    key                  = "module-repo-setup/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  partner_id = "1782f57c-edb6-4bf8-bd26-c7e0ef75c1e8"
}

provider "github" {
  owner = "cloudeteer"
}

data "github_repositories" "repositories" {
  query = "org:cloudeteer topic:auto-terraform-governance"
}

output "terraform_module_repositories" {
  value = toset(concat(
    data.github_repositories.repositories.names,
    tolist(contains([null, "", "null"], var.create_repo) ? [] : [var.create_repo])
  ))
}

module "github_repository" {
  source = "./modules/github_repository"
  for_each = toset(concat(
    data.github_repositories.repositories.names,
    tolist(contains([null, "", "null"], var.create_repo) ? [] : [var.create_repo])
  ))
  repository_name = each.value
}
