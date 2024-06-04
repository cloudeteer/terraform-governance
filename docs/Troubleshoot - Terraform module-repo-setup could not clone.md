---
tags:
  - troubleshoot
---

# Troubleshoot - Terraform module-repo-setup could not clone

## Problem

<!--
Describe the problem as the user would experience it. For example "Level 7
printer is flashing red and wont print".
-->

When running the CI Job `module-repo-setup`, the following error is thrown:

```plain
module.github_repository["terraform-test-autocreated1"].github_repository.repository: Creating...
╷
│ Error: POST https://api.github.com/repos/cloudeteer/terraform-module-template/generate: 422 Could not clone: Name already exists on this account [{Resource: Field: Code: Message:Could not clone: Name already exists on this account}]
│ 
│   with module.github_repository["terraform-test-autocreated1"].github_repository.repository,
│   on modules/github_repository/main.tf line 16, in resource "github_repository" "repository":
│   16: resource "github_repository" "repository" {
│ 
╵
Error: Process completed with exit code 1.
```

## Solution

<!--
Provide steps that the user can take to solve the problem. For example "The
level 7 printer will flash red when it is out of paper. Add paper to tray 1".
-->

The repository is already created on the GitHub account.
The error message `Could not clone: Name already exists on this account` indicates that the repository with the same name already exists on the GitHub account.

To resolve this issue you need to import the existing repository into the Terraform state.

---
1. prepare Project in Github:
   1. add topics "terraform-module,auto-terraform-governance" to repository
   2. add collaborator "cloudeteerbot" with admin permission to repository
2. in terraform-governance code: Navigate to `terraform`-folder in the repository.
3. Either
   - Import the existing repository into the Terraform state.
     ```bash
     # only github_repository is needed, so terraform doesn't try to create it
     tofu import 'module.github_repository["terraform-test-autocreated1"].github_repository.repository' terraform-test-autocreated1
     ```
   - OR add repo to `terraform/import.tf`
4. commit and run module-repo-setup action in Github
---

## Related articles

<!-- List related articles here -->

<!--
- [Troubleshoot - Start Menü suche funktioniert nicht.md][related-troubleshoot]
-->

<!-- Put link references here -->

[related-troubleshoot]: <../troubleshoot/Troubleshoot - Start Menü suche funktioniert nicht.md>
