# Pre-Commit

## What is Pre-Commit
Pre-Commit is a powerful tool that helps developers make high-quality, consistent, and error-free code changes.
It integrates seamlessly into the development workflow, minimizes manual reviews,
and ensures that issues are detected early—long before they reach the production environment.


For more information visit https://pre-commit.com

## Already in use
Every Module-Repository of us has certain checks on a pull-request to prevent formatting and documentation errors.
By using pre-commit, all checks will be done locally and sometimes even be fixed automatically, which increase productivity and decrease the hassle with
the pull-request checks.

## Installing
### Mac
`brew install pre-commit`

### Windows
:no_good:

### Linux
`pip install pre-commit`

### Enable Pre-Commit
Run this command in your local repository in which you want to use it:  
`pre-commit install`

## Pre-Commit Examples (we use)
In order to know what pre-commits are used in each repository,
look out for [pre-commit-config.yaml](https://github.com/cloudeteer/terraform-governance/blob/main/pre-commit-config.yaml),
but here are some simple examples to get in touch with it.
- terraform-docs
  - A utility to generate documentation from Terraform modules in various output formats.
- terraform-lint
  - Validates all Terraform configuration files with [TFLint](https://github.com/terraform-linters/tflint). [Available TFLint rules](https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md). [Hook notes](https://github.com/antonbabenko/pre-commit-terraform?tab=readme-ov-file#terraform_tflint).
- end-of-file-fixer
  - Makes sure files end in a newline and only a newline.

## Skip Pre-Commit once
Not all Pre-Commit hooks are perfect, and sometimes you want to commit your code even if not all pre-commit hooks are successful.
To do so, just use the `--no-verify` option of git:  
`git commit --no-verify -m "commit message"`

## Uninstall
Just run in your local git repository:  
`pre-commit uninstall`