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
  query = "org:cloudeteer topic:terraform-module topic:auto-terraform-governance"
}

output "terraform_module_repositories" {
  value = toset(concat(
    data.github_repositories.repositories.names,
      var.create_repo != null && var.create_repo != "" ? tolist([var.create_repo]) : []
  ))
}

# https://developer.hashicorp.com/terraform/language/import
### works, but have to be a loop
# import {
#   id = "terraform-test-autocreated1"
#   to = module.github_repository["terraform-test-autocreated1"].github_repository.repository
# }

### import not working
# data "template_file" "import" {
#   template = file("${path.module}/import.tf.tpl")
#   vars = {
#     repository_names = join(", ", data.github_repositories.repositories.names)
#   }
# }
# resource "local_file" "import" {
#   content  = data.template_file.import.rendered
#   filename = "${path.module}/import.tf"
# }

module "github_repository" {
  source = "./modules/github_repository"
  for_each = toset(concat(
    data.github_repositories.repositories.names,
      var.create_repo != null && var.create_repo != "" ? tolist([var.create_repo]) : []
  ))
  repository_name = each.value
}
