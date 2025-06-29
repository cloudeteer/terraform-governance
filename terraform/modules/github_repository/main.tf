locals {
  provider = split("-", var.repository_name)[2]
  provider_formatted = (local.provider == "azurerm" ? "AzureRM" :
  (local.provider == "aws" ? "AWS" : local.provider))
  module_name  = join("-", slice(split("-", var.repository_name), 2, length(split("-", var.repository_name))))
  visibility   = coalesce(data.github_repository.existing_repo[0].visibility, "public")
  description  = coalesce(data.github_repository.existing_repo[0].description, "☁️ Cloudeteer's Terraform ${local.provider_formatted} ${local.module_name} module")
  is_template  = data.github_repository.existing_repo[0].is_template
  homepage_url = coalesce(data.github_repository.existing_repo[0].homepage_url, "https://www.cloudeteer.de")
  combined_topics = concat(
    coalesce(data.github_repository.existing_repo[0].topics, []),
    ["cloudeteer", "terraform", "terraform-module", "auto-terraform-governance"]
  )
}

data "github_repository" "existing_repo" {
  count     = 1
  full_name = "cloudeteer/${var.repository_name}"
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
resource "github_repository" "repository" {
  name                        = var.repository_name
  visibility                  = local.visibility
  description                 = local.description
  has_discussions             = true
  has_issues                  = true
  has_projects                = false
  has_wiki                    = false
  has_downloads               = false
  allow_auto_merge            = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  allow_squash_merge          = true
  allow_update_branch         = true
  squash_merge_commit_message = "BLANK"
  squash_merge_commit_title   = "PR_TITLE"
  topics                      = local.combined_topics
  homepage_url                = local.homepage_url
  vulnerability_alerts        = true
  # may cause "Commit signoff is enforced by the organization and cannot be disabled" https://github.com/integrations/terraform-provider-github/issues/2077
  web_commit_signoff_required = true
  delete_branch_on_merge      = true
  is_template                 = local.is_template
  # https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository#template-repositories
  template {
    owner      = "cloudeteer"
    repository = "terraform-module-template"
  }
  lifecycle {
    prevent_destroy = true
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
    team_id    = "6206668" # team-slug: service-accounts
  }
  team {
    permission = "admin"
    team_id    = "5433329" # team-slug: chapter-operations-engineering
  }
  # Do not delete "cloudeteerbot" as admin even it is part of "service-accounts",
  # because there is a race-condition in the deployment situation.
  user {
    permission = "admin"
    username   = "cloudeteerbot"
  }
}

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret
resource "github_actions_secret" "this" {
  for_each = nonsensitive(var.actions_secrets)

  secret_name     = each.key
  plaintext_value = sensitive(each.value)

  repository = github_repository.repository.name
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

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
resource "github_branch_protection" "ruleset_branch_default_protect" {
  //enforcement = "active"
  //target      = "branch"
  repository_id                   = github_repository.repository.name
  pattern                         = "main"
  require_conversation_resolution = true
  required_linear_history         = true
  required_status_checks {
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    require_code_owner_reviews      = true
    required_approving_review_count = 1
    require_last_push_approval      = true
  }
  restrict_pushes {
    blocks_creations = true
  }
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
  repository  = github_repository.repository.name
  name        = "breaking-change"
  description = "Breaking changes requiring user action or updates"
  color       = "b60205"
}

resource "github_issue_label" "ignore_release" {
  repository  = github_repository.repository.name
  name        = "ignore-release"
  description = "Does not trigger a release or changelog entry"
  color       = "e4e669"
}

resource "github_issue_label" "other" {
  repository = github_repository.repository.name
  name       = "other"
  color      = "cfd3d7"
}

resource "github_repository_custom_property" "auto_terraform_governance" {
  repository = github_repository.repository.name
  property_name  = "auto-terraform-governance"
  property_type  = "true_false"
  property_value = ["true"]
}
