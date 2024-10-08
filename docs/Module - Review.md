# Module Review Guide

This document outlines the key points to consider when reviewing a CLOUDETEER Terraform module.

## Scope

All changes or new Terraform modules are made through GitHub Pull Requests (PRs). Each PR triggers GitHub Actions that run various automated tests. This guide highlights the manual checks a reviewer should perform during the review process.

## Review Checklist

### Pull Request Title

The PR title is used as the commit message in a "Squash and Commit" scenario and is also the release note message. Therefore, the PR title must be carefully crafted.

Both the reviewer and the person merging the PR have the authority to edit the PR title. Ensure that the title meets the requirements of a well-formed commit message.

### Semantic Versioning

Verify if the semantic versioning label corresponds to the actual code changes. For example:

- Is a PR labeled as `breaking` genuinely a breaking change, requiring a major version bump?
- Does a `feature` label imply a minor update, or should it be a `fix` or even a `breaking` change?

Ask yourself: Does this PR implement a `fix`, `feature`, or `breaking` change?

| Label      | Description                                                                   | Semantic Version Update |
| ---------- | ----------------------------------------------------------------------------- | ----------------------- |
| `fix`      | **PATCH**: for backward-compatible bug fixes.                                  | `v1.2.3` → `v1.2.4`     |
| `feature`  | **MINOR**: for adding backward-compatible functionality.                      | `v1.2.3` → `v1.3.0`     |
| `breaking` | **MAJOR**: for incompatible API changes.                                      | `v1.2.3` → `v2.0.0`     |

### GitHub Checks

Ensure all GitHub checks are passing (green). Also, verify if the latest module-ci workflow is being used.

### Configuration files

- Compare configuration against the standard module configuration files:
  - `.gitignore`
  - `.pre-commit-config.yaml`
  - `.terraform-docs.yaml`
  - `.tflint.examples.hcl`
  - `.tflint.tests.hcl`
  - `.tflint.hcl`
  - `renovate.json`

### Code Style

Review the code according to the [Terraform Style Guide](Development%20-%20Terraform%20Style%20Guide.md).

These are just some examples of critical elements to review from the style guide. However, the entire style guide should be considered when reviewing a module change.

#### Module Structure

- Ensure no unnecessary or obsolete files are included (e.g., `CHANGELOG.md`).
- Check Terraform file structure:
  - Validate that `main.tf` is used, or alternatively, `d-*.tf` and `r-*.tf`.
  - Review [HCL labels](https://developer.hashicorp.com/terraform/language#about-the-terraform-language) (Name of Azure Resource) for clarity and descriptiveness.
  - Confirm output descriptions in `output.tf` are present and use meaningful names—avoid abbreviations.
  - Ensure Azure locations use API values, not friendly names (in both code and tests).

#### Terraform Tests

- Decide whether to allow combined mock files (e.g., `data.tfmock.hcl`), or split each mock into separate files.
- Use the UUID `00000000-0000-0000-0000-000000000000` in mocks to signify that they are placeholders.
- Ensure there is one empty line between code blocks.

#### Documentation (README.md)

- If this is a public repository, ensure the appropriate header is present.
- The H1 title should match the repository name.
- Review the module description and any free-form content above the autogenerated sections.
- Use a markdown linter to validate (automate this if possible).
- Do not review autogenerated content in the README directly. Instead, review the source files (e.g., `examples/usage`, `variables.tf`).

#### Terraform Variables

- Ensure variable names are consistent and reflect the resource or attribute being used.
- Check that variable descriptions are clear and meaningful.
- Test all variable validations using local tests as per the Style Guide.