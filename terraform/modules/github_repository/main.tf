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
  name                 = var.repository_name
  visibility           = "private"
  has_discussions      = true
  has_issues           = true
  has_projects         = false
  has_wiki             = false
  has_downloads        = false
  allow_merge_commit   = false
  allow_rebase_merge   = false
  allow_squash_merge   = true
  topics               = ["terraform", "terraform-module", "auto-terraform-governance"]
  vulnerability_alerts = true
  # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#template-repositories
  template {
    owner      = "cloudeteer"
    repository = "terraform-module-template"
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborators
# token permissions:
# - repo
# - read:org
resource "github_repository_collaborators" "admins" {
  repository = github_repository.repository.name
  # get id: $ gh api /orgs/cloudeteer/teams/service-accounts | jq '.id'
  team {
    permission = "admin"
    team_id    = "service-accounts" # id: 6206668
  }
  user {
    permission = "admin"
    username   = "cloudeteerbot"
  }
  user {
    permission = "admin"
    username   = "lixhunter"
  }
  user {
    permission = "admin"
    username   = "rswrz"
  }
  user {
    permission = "admin"
    username   = "Phil-Thoennissen"
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

resource "github_issue_label" "fix" {
  repository = github_repository.repository.name
  name       = "fix"
  color      = "d73a4a"
}

resource "github_issue_label" "feature" {
  repository = github_repository.repository.name
  name       = "feature"
  color      = "a2eeef"
}

resource "github_issue_label" "breaking_change" {
  repository = github_repository.repository.name
  name       = "breaking-change"
  color      = "b60205"
}

resource "github_issue_label" "ignore_release" {
  repository = github_repository.repository.name
  name       = "ignore-release"
  color      = "e4e669"
}

resource "github_issue_label" "other" {
  repository = github_repository.repository.name
  name       = "other"
  color      = "cfd3d7"
}
