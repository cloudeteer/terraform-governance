variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
resource "github_repository" "repository" {
  name     = var.repository_name
  visibility      = "private"
  has_discussions = false
  has_issues      = false
  has_projects    = false
  has_wiki        = false
  has_downloads   = false
  allow_merge_commit = false
  allow_rebase_merge = false
  topics = ["terraform", "terraform-module"]
  vulnerability_alerts = true
  # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#template-repositories
  template {
    owner      = "cloudeteer"
    repository = "terraform-module-template"
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch
resource "github_branch" "branch_main" {
  repository = github_repository.repository.name
  branch     = "main"
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default
resource "github_branch_default" "branch_default" {
  repository = github_repository.repository.name
  branch     = github_branch.branch_main.branch
}
