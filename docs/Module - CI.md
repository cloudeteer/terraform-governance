# Module CI

Use the following GitHub workflow to make use of the `module-ci.yaml` reusable workflow. This workflow should be use in every module repository.

Filename: `./github/workflows/module-ci.yaml`

```yaml
name: module-ci
on:
  push:
    branches:
      - main
  pull_request:
    types:
      - opened
      - edited
      - synchronize
      - labeled
      - unlabeled
jobs:
  module-ci:
    uses: cloudeteer/terraform-governance/.github/workflows/module-ci.yaml@main
    permissions:
      contents: write
      pull-requests: read
```
