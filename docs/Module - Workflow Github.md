# Module - Workflow Github Overview

## Usage

File : [`.github/workflows/module-github.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github.yaml)

Use the following GitHub workflow to make use of the `module-github-project.yaml` reusable workflow. This workflow should be used in every module repository.

Filename in module Repository: `./github/workflows/module-github-project.yaml`

```yaml
name: module-manage-github
on:
  push:
    branches:
      - main
  issues:
    types:
      - opened
  pull_request:
    types:
      - opened
      - reopened
      - synchronize
      - labeled
      - unlabeled

jobs:
  module-manage-github:
    uses: cloudeteer/terraform-governance/.github/workflows/module-github.yaml@main
    permissions:
      contents: write
      pull-requests: read
    secrets: inherit
```

> [!IMPORTANT]
> The following secret and variable are required and must be available in the module repository and are inherited by the Module GitHub workflow.
>
> - `secrets.ORGA_GITHUB_APP_SECRET_CDTGITHUBPROJECTMANAGEMENT`
> - `vars.ORGA_GITHUB_APP_ID_CDTGITHUBPROJECTMANAGEMENT`

### Inputs

| Name              | Description                                          | Type      | Default |
| ----------------- | ---------------------------------------------------- | --------- | ------- |
| `run_job_project` | Determines whether to run the project management job | `boolean` | `false` |

## Purpose

The `module-manage-github` workflow serves as an entry point for GitHub management tasks. It calls modular workflows for managing GitHub projects, handling pull requests, and automating releases.

This workflow enforces standardized practices across project management, pull request handling, and release automation. The use of permissions and secrets further ensures secure and controlled operations. Ultimately, this workflow reduces manual overhead, promotes collaboration, and helps maintain a well-organized repository management process.

See the following sections for detailed information on each modular workflow.

## Trigger

This workflow is triggered using `workflow_call`, allowing other workflows to invoke it with specific inputs.

## Workflows

### Module GitHub Project

File : [`.github/workflows/module-github-project.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-project.yaml)

This workflow automates the management of GitHub projects by interacting with a specific project URL.

### Module GitHub Pull Request

File : [`.github/workflows/module-github-pull-request.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-pull-request.yaml)

The `module-ci-pull-request` workflow ensures pull requests have exactly one required label, enforcing labeling best practices.

### Module GitHub Release

File : [`.github/workflows/module-github-release.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-release.yaml)

Automates semantic versioning and GitHub releases based on pull request labels.
