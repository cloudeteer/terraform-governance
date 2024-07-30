---
tags:
  - module
---

# Module - Publish and Release

This documentation describes how to publish a Terraform module and release new versions.

## Publish a Module

### Terraform Registry

Official documentation from HashiCorp on publishing modules: <https://developer.hashicorp.com/terraform/registry/modules/publish>

Requirements from the Terraform Registry:

- The GitHub App "Terraform Registry" needs permissions to read repositories and create webhooks in the [cloudeteer](https://github.com/cloudeteer) GitHub organization. This was initially set up in issue <https://github.com/cloudeteer/tf-mod-lib/issues/360>.

Requirements from Cloudeteer:

- Modules must be published using the [cloudeteerbot](https://github.com/cloudeteerbot) GitHub user.

Step-by-step guide:

1. Log in to the Terraform Registry with the [cloudeteerbot](https://github.com/cloudeteerbot) GitHub user.
2. Publish a new module as documented in the HashiCorp Terraform Registry documentation: <https://developer.hashicorp.com/terraform/registry/modules/publish#publishing-a-public-module>

### OpenTofu Registry

Follow the module publishing notes at <https://github.com/opentofu/registry/>. At the time of writing this documentation, the steps are:

1. Create a GitHub issue "Submit new Module" in <https://github.com/opentofu/registry/> filling out all required fields.
2. Wait for the request to be processed and approved. A pull request will be created and merged.

Example: <https://github.com/opentofu/registry/issues/635>

## Release a New Module Version

### Terraform Registry

During the initial publishing of a Terraform module in the Terraform Registry, the "Terraform Registry" GitHub App installs a webhook in the GitHub repo of the Terraform module. This webhook ensures that on a _tag-push_ (Semantic Version), the module is automatically published in the Terraform Registry.

Official HashiCorp documentation: <https://developer.hashicorp.com/terraform/registry/modules/publish#releasing-new-versions>

### OpenTofu Registry

Once a module is registered in the OpenTofu registry, OpenTofu automation will automatically monitor for new releases of the registered module. This is done by watching for new Git tags in Semantic Version format. Pushing such a tag will trigger a new release on OpenTofu, similar to how it works on Terraform. No further action is required from the module developers.
