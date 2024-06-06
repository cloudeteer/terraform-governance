# Module CI

Use the following GitHub workflow to make use of the `module-ci.yaml` reusable workflow. This workflow should be use in every module repository.

Filename: `./github/workflows/module-ci.yaml`

```yaml
name: module-ci
on: [push, pull_request]
jobs:
  module-ci:
    uses: cloudeteer/terraform-governance/.github/workflows/module-ci.yaml@main
```
