# Module - Workflow CI Overview

## Usage

File : [`.github/workflows/module-ci.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci.yaml)

Use the following GitHub workflow to make use of the `module-ci.yaml` reusable workflow. This workflow should be used in every module repository.

Filename in module Repository: `.github/workflows/module-ci.yaml`

```yaml
name: module-ci
on:
  workflow_dispatch:
  schedule:
    - cron: "0 0 * * 0" # weekly on Sunday at 00:00
  pull_request:
    types:
      - opened
      - edited
      - synchronize
      - ready_for_review

jobs:
  module-ci:
    uses: cloudeteer/terraform-governance/.github/workflows/module-ci.yaml@main
    permissions:
      contents: read
      issues: write
      id-token: write
    secrets: inherit
```

> [!IMPORTANT]
> The following secrets are required for the remote test, which deploys Azure resources to a specific Azure subscription. Instead of using a client secret, the deployment leverages an Azure Managed Identity with workflow federation.
>
> These secrets must be available in the module repository and are inherited by the Module CI workflow.
>
> - `ARM_CLIENT_ID`: Azure client ID
> - `ARM_SUBSCRIPTION_ID`: Azure subscription ID
> - `ARM_TENANT_ID`: Azure tenant ID

## Purpose

The `module-ci` workflow orchestrates multiple modular workflows for validation, linting, documentation, code analysis, and testing. Additionally, it automates the creation of GitHub issues for failed scheduled workflows.

By triggering on key events such as pushes to the main branch or changes to pull requests (e.g., opening, editing, synchronization), it ensures that every significant modification undergoes rigorous validation and quality checks. This proactive approach minimizes the risk of introducing issues, enhances collaboration through immediate feedback, and keeps the codebase in a deployable state. Additionally, the workflow's ability to create GitHub issues for failed jobs ensures that problems are promptly identified and systematically resolved, reinforcing accountability and team productivity.

See the following sections for detailed information on each modular workflow.

## Trigger

This workflow is triggered using `workflow_call` to allow reuse by other workflows.

## Jobs

1. Validate : Ensures Terraform configurations are valid by running the [`module-ci-validate.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-validate.yaml) workflow
2. Lint : Enforces best practices using the [`module-ci-lint.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-lint.yaml) workflow
3. Documentation : Generates and validates Terraform module documentation using the [`module-ci-documentation.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-documentation.yaml) workflow
4. Code Analysis : Scans for misconfigurations and secrets using the [`module-ci-code-analysis.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-code-analysis.yaml) workflow
5. Test : Runs various Terraform tests, including local unit tests and remote real-world deployments, using the [`module-ci-test.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-test.yaml) workflow
6. Issue Creation : Creates GitHub issues for failed workflows by calling the [`module-ci-issue.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-issue.yaml) workflow

## Workflows

### Module CI Validate

File : [`.github/workflows/module-ci-validate.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-validate.yaml)

This workflow validates Terraform configurations to ensure they are syntactically correct, formatted properly, and meet validation standards.

### Module CI Lint

File : [`.github/workflows/module-ci-lint.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-lint.yaml)

The `module-ci-lint` workflow ensures that Terraform configurations adhere to best practices using TFLint, a linter specifically designed for Terraform.

### Module CI Documentation

File : [`.github/workflows/module-ci-documentation.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-documentation.yaml)

This workflow validates the Terraform module documentation using `terraform-docs`. It ensures that documentation is consistent with the module's actual configuration.

### Module CI Code Analysis

File : [`.github/workflows/module-ci-code-analysis.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-code-analysis.yaml)

This workflow scans Terraform configurations for misconfigurations and detects exposed secrets using [Trivy](https://trivy.dev), a powerful security and configuration analysis tool.

### Module CI Test

File : [`.github/workflows/module-ci-test.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-test.yaml)

This workflow runs Terraform tests (examples, local, and remote) to ensure that module configurations function as intended.

### Module CI Issue

File : [`.github/workflows/module-ci-issue.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-issue.yaml)

Automatically creates a GitHub issue if a scheduled workflow fails, providing visibility into workflow failures.
