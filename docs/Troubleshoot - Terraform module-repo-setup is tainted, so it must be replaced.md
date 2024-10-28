---
tags:
  - troubleshoot
---

# Troubleshoot - Terraform module-repo-setup is tainted, so it must be replaced

## Problem

<!--
Describe the problem as the user would experience it. For example "Level 7
printer is flashing red and wont print".
-->

When running the CI Job `module-repo-setup`, the following error is thrown:

```plain
OpenTofu used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

OpenTofu planned the following actions, but then encountered a problem:

  # module.github_repository["terraform-azurerm-avd"].github_repository.repository is tainted, so it must be replaced
-/+ resource "github_repository" "repository" {
      - allow_update_branch         = false -> null
      ~ default_branch              = "main" -> (known after apply)
╷
│ Error: Instance cannot be destroyed
│ 
│   on modules/github_repository/main.tf line 42:
│   42: resource "github_repository" "repository" {
│ 
│ Resource
      ~ etag                        = "W/\"6b121950519cd7492bb13e9254e60f60dae3fd14f69620b313b365871459b597\"" -> (known after apply)
│ module.github_repository["terraform-azurerm-avd"].github_repository.repository
│ has lifecycle.prevent_destroy set, but the plan calls for this resource to
│ be destroyed. To avoid this error and continue with the plan, either
│ disable lifecycle.prevent_destroy or reduce the scope of the plan using the
│ -target flag.
╵
```

## Solution

<!--
Provide steps that the user can take to solve the problem. For example "The
level 7 printer will flash red when it is out of paper. Add paper to tray 1".
-->

The Repository is already created in Github and the Terraform state is not in sync with the actual state of the repository.

Replace is prohibited by `lifecycle.prevent_destroy` setting.

To resolve this issue first cleanup the tainted resource, by

- removing it from the configuration and remove
- remove it from terraform state

---
1. prepare cleanup on Project in Github:
   1. remove topic "auto-terraform-governance" from repository
2. adhoc modify current terraform state
   ```bash
   tofu state remove "module.github_repository[\"terraform-azurerm-avd\"]" -dry-run
   ```
   > [!NOTE]
   > always use `-dry-run` first to verify the changes, then remove the flag to apply the changes
3. Run module-repo-setup action in Github and verify the changes

---
After that you can re-add the repository to the configuration by following the Solution steps in the [Troubleshoot - Terraform module-repo-setup could not clone][related-troubleshoot].

### Solution Note

In Terraform this can be solved in removed blocks, but the [lifecycle block is not supported by OpenTofu][open-tofu-removed-block].

```hcl
removed {
  from = github_repository.terraform-azurerm-avd
  
  # not supported by OpenTofu
  lifecycle {
    destroy = false
  }
}
```

## Related articles

<!-- List related articles here -->

- [Troubleshoot - Terraform module-repo-setup could not clone][related-troubleshoot]
- [The OpenTofu removed block works differently from the Terraform variant][open-tofu-removed-block]

<!-- Put link references here -->

[related-troubleshoot]: <./Troubleshoot%20-%20Terraform%20module-repo-setup%20could%20not%20clone.md#solution>
[open-tofu-removed-block]: <https://github.com/opentofu/opentofu/blob/de9fb7ccca5d02b7b675a036993bc5edcbd28c05/website/docs/intro/migration/terraform-1.8.mdx#removed-block>
