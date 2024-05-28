terraform {
  # https://registry.terraform.io/providers/integrations/github/latest/docs
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstates-westeurope-001"
    storage_account_name = "stcdtoetfstate"
    container_name       = "terraform-governance"
    key                  = "module-repo-setup/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  partner_id = "1782f57c-edb6-4bf8-bd26-c7e0ef75c1e8"
}

# https://registry.terraform.io/providers/integrations/github/latest/docs#github-app-installation
provider "github" {
  token = var.github_token
  owner = "cloudeteer"
}

data "github_repositories" "repositories" {
  query = "org:cloudeteer topic:terraform-module"
}

output "terraform_module_repositories" {
  value = toset(concat(data.github_repositories.repositories.names, coalesce(var.create_repos, [])))
}

module "github_repository" {
  source = "./modules/github_repository"
  for_each = toset(concat(data.github_repositories.repositories.names, coalesce(var.create_repos, [])))
  repository_name = each.value
}
