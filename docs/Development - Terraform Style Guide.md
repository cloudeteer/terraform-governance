# Terraform Style Guide

This guide provides the standards and best practices for developing Terraform modules at CLOUDETEER. It is designed to ensure clarity, readability, and consistency across all Terraform projects. These are recommendations to be followed as much as possible.

We adhere to the [Terraform Official Style Guide](https://developer.hashicorp.com/terraform/language/style) and augment it with the following conventions.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [General Formatting](#general-formatting)
- [Resources and Data Sources](#resources-and-data-sources)
- [Variables](#variables)
- [Outputs](#outputs)
- [Module Structure](#module-structure)
  - [Required Folders](#required-folders)
  - [File Structure](#file-structure)
- [Documentation](#documentation)
  - [Public Module Headers](#public-module-headers)
- [Examples](#examples)
- [Linting](#linting)
- [Testing](#testing)
  - [Testing Guidelines](#testing-guidelines)
  - [Test Naming Conventions](#test-naming-conventions)
- [Pre-Commit Hooks](#pre-commit-hooks)
- [GitHub Module CI](#github-module-ci)
- [Renovate](#renovate)
- [Community Docs](#community-docs)
- [License](#license)

---

## General Formatting

- Use `terraform fmt` to enforce consistent formatting.
- Pre-commit hooks must be added to ensure auto-formatting, linting and code scanning repositories.
- Set a line length limit of **120 characters**.
  - _Exception_: Single-line description strings in variables and output blocks.

## Resources and Data Sources

- Use descriptive names. If there’s only one resource, use `this`. For example, in an Azure Virtual Network, use `azurerm_virtual_network.this` and descriptive names like `private`, `public`, or `database` for multiple instances of `azurerm_subnet`.
- Always use singular nouns for names.
- Include `tags` (if applicable) as the last argument, followed by `depends_on` and `lifecycle`. Separate these with an empty line.
- If [`ignore_changes`](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle#ignore_changes) is used, each ignored attribute must be preceded by a comment explaining why it is being ignored by default.

## Variables

- Do not create custom names for variables where standard arguments already exist. Follow the argument names from the resource's "Argument Reference".
- For variables of type `list(...)` and `map(...)`, use plural form in the variable name.
- Prefer `list` over `map` types unless absolutely necessary. For example, use a list of objects instead of a map with element keys.
- Alphabetically sort variables in the `variables.tf` file. Use [tfsort](https://github.com/AlexNabokikh/tfsort) for assistance.
- Complex types should use concrete objects (`object` type) over free-form `map` types.
- Multiline descriptions for complex variables should describe each key in a Markdown table in the variable description.
- Use [Heredoc String](https://developer.hashicorp.com/terraform/language/expressions/strings#heredoc-strings) for multiline string in variable description field.

## Outputs

- Do not create custom names for outputs where standard attributes of resources already exist. Follow the attribute names from the resource's "Attributes Reference.
- Outputs must be meaningful and intuitive even when used outside the module.
- If the output type is `list` or `map`, the name must be plural.

## Module Structure

### Required Folders

Each module repository must include the following directory structure:

- **`examples/usage/`**  
  Contains a fully functional example demonstrating how to use the module. This example should serve as a reference implementation, showcasing all key features and expected usage patterns of the module.

- **`tests/examples/`**  
  Contains test files that validate the examples in the `examples/` folder. For instance, if the main example is `usage`, the corresponding test should be named `usage.tftest.hcl`. These tests ensure that the examples remain functional as changes are made to the module.

- **`tests/local/`**  
  Contains local unit tests for the module, typically run during development. Tests can be stored in a single `main.tftest.hcl` file or split into multiple files for better organization. These tests should mock external dependencies, allowing for quick feedback without requiring actual infrastructure.

- **`tests/remote/`**  
  Contains tests that perform real deployments using actual cloud providers. These tests are designed to run in CI pipelines (e.g., on pull requests) and validate the module’s functionality in a fully deployed environment. Remote tests ensure that the module works as expected in production-like scenarios.

### File Structure

Each module repository must include the following Terraform files:

- **`terraform.tf`**  
  Contains a single `terraform` block specifying the module's `required_version` of Terraform and `required_providers`. This ensures compatibility and enforces consistent versions across environments.

- **`variables.tf`**  
  Defines all input variables for the module. This file organizes and documents the inputs needed to configure the module effectively.

- **`outputs.tf`**  
  Contains the module's output definitions. All values that the module returns for external use must be defined here to ensure clarity and usability.

- **`main.tf`**  
  For simple modules, all core logic should be placed in this file.
  For more complex modules:

  - **Resources**: Group and organize resource blocks into separate files with meaningful and intuitive names, prefixed with `r-`. Example: `r-network.tf`.
  - **Data sources**: Similarly, organize data source blocks into separate files with meaningful names, prefixed with `d-`. Example: `d-identity.tf`.

- **`README.md`**:  
  The complete module documentation which autogenerated content, see [documentation](#documentation).

## Documentation

- The **h1 title** of the `README.md` must match the repository name, e.g., `# terraform-azurerm-vm`. Directly below the title, provide a concise and informative description of the module’s purpose and functionality.

- Use `terraform-docs` to automatically generate the documentation for your module. Place the autogenerated content between `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->`. This should appear after the initial module description to maintain a clean and structured layout.

- Ensure the `.terraform-docs.yaml` configuration file is consistent with the [global configuration](../terraform-docs.yaml) used in CI tests. This guarantees uniform documentation output across all modules and prevents discrepancies during CI validation.

- **All links** within the `README.md` must be absolute URLs (e.g., full URLs starting with `https://`) to ensure that they render correctly on the Terraform Registry website.

### Public Module Headers

For public modules, add this header to the `README.md`, above the h1 title:

```markdown
<!-- markdownlint-disable first-line-h1 no-inline-html -->

> [!NOTE]
> This repository is publicly accessible as part of our open-source initiative. We welcome contributions from the community alongside our organization's primary development efforts.

---
```

## Examples

- Every module must include at least one example in `./examples/usage/main.tf` and provide a description in `./examples/usage/main.md`.
- Ensure that examples are tested with corresponding tests located in `./tests/examples/`.
- All examples should include `test_override.tf`, specifying providers and overriding the `source` to `../..` to ensure testing uses the current codebase.

## Linting

- Use `TFLint` for linting, adhering to best practices from both default and custom rules.
- Exceptions are allowed for `./examples`, but these exceptions must be documented in the `tflint.examples.hcl` configuration file.
- The `TFLint` configuration must match the global configuration file used in CI tests.

## Testing

There are three levels of testing:

1. **Examples**
2. **Local**
3. **Remote**

### Testing Guidelines

- **Examples/Local**: Use `mock_provider` for local tests. All tests must be able to run without an active session on any cloud provider.
- **Remote**: Executes real deployments using real providers. Sensitive information (e.g., `subscription_id` for Azure) must be passed via environment variables and must not be hardcoded into the module tests.
- Mocks must be stored in `./{examples,local,remote}/mocks`. Each mock should be defined in its own file, named after the resource being mocked.

### Test Naming Conventions

- Test files should be named `main.tftest.hcl` unless split into multiple files.
- Labels within `run {}` blocks must clearly describe the test, using `should` or `expect` (e.g., `should_fail_with_no_subnet_id`).

## Pre-Commit Hooks

- Use pre-commit hooks to ensure code is valid, formatted, and documented before committing.
- Every module must include a `.pre-commit.yaml` file matching the [global configuration](../pre-commit-config.yaml). This is enforced during CI tests.

## GitHub Module CI

- Every module must use the standard reusable GitHub Actions workflow at `cloudeteer/terraform-governance/.github/workflows/module-ci.yaml` for CI testing.

## Renovate

- Each module repository must include a `renovate.json` configuration, which is validated against the [global configuration](../renovate-default.json).

## Community Docs

- Each repository must include a `CONTRIBUTING.md` file linking to the [global contributing guidelines](../CONTRIBUTING.md).

## License

- All public modules must include a valid `LICENSE` file. The default license for CLOUDETEER is MIT.
