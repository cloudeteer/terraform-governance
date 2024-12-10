# Module CI - Workflow Overview

## **Module CI**
**File**: [`.github/workflows/module-ci.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci.yaml)

### **Purpose**
The `module-ci` workflow orchestrates multiple modular workflows for validation, linting, documentation, code analysis, and testing. Additionally, it automates the creation of GitHub issues for failed scheduled workflows.

### **Triggers**
This workflow is triggered using `workflow_call` to allow reuse by other workflows.  

It requires the following secrets:
- `ARM_CLIENT_ID`: Azure client ID
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID
- `ARM_TENANT_ID`: Azure tenant ID

### **Jobs**
1. **Validate**: Ensures Terraform configurations are valid by running the [`module-ci-validate.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-validate.yaml) workflow
2. **Lint**: Enforces best practices using the [`module-ci-lint.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-lint.yaml) workflow
3. **Documentation**: Generates and validates Terraform module documentation using the [`module-ci-documentation.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-documentation.yaml) workflow
4. **Code Analysis**: Scans for misconfigurations and secrets using the [`module-ci-code-analysis.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-code-analysis.yaml) workflow
5. **Test**: Runs Terraform tests in various environments via the [`module-ci-test.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-test.yaml) workflow
6. **Issue Creation**: Creates GitHub issues for failed workflows by calling the [`module-ci-issue.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-issue.yaml) workflow

---

## **Module CI Validate**
**File**: [`.github/workflows/module-ci-validate.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-validate.yaml)

### **Purpose**
This workflow validates Terraform configurations to ensure they are syntactically correct, formatted properly, and meet validation standards.

### **Steps**
1. **Repository Checkout**: Clones the repository for validation
2. **Fetch Terraform Version**: Determines the required Terraform version using a custom action
3. **Terraform Setup**: Installs and configures Terraform based on the required version
4. **Terraform Initialization**: Runs `terraform init` with `-backend=false` to skip backend configuration
5. **Format Check**: Ensures consistent code style using `terraform fmt`
6. **Validation**: Checks the validity of Terraform configurations using `terraform validate`

---

## **Module CI Lint**
**File**: [`.github/workflows/module-ci-lint.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-lint.yaml)

### **Purpose**
The `module-ci-lint` workflow ensures that Terraform configurations adhere to best practices using TFLint, a linter specifically designed for Terraform.

### **Steps**
1. **Repository Checkout**: Clones the repository for linting
2. **Fetch Terraform Version**: Identifies the Terraform version needed for linting
3. **Terraform Setup**: Installs and configures Terraform for compatibility with TFLint
4. **TFLint Configuration Sync**: Pulls TFLint configuration files from the governance repository to ensure consistency across projects
5. **TFLint Setup**: Installs and initializes TFLint, including plugins
6. **Lint Execution**: Runs TFLint checks on Terraform configurations, including module examples, to ensure compliance with defined rules

---

## **Module CI Documentation**
**File**: [`.github/workflows/module-ci-documentation.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-documentation.yaml)

### **Purpose**
This workflow automates the generation and validation of Terraform module documentation using `terraform-docs`. It ensures that documentation is consistent with the module's actual configuration.

### **Steps**
1. **Install Prerequisites**: Ensures necessary dependencies are available in the environment
2. **Repository Checkout**: Clones the repository to validate documentation
3. **Configuration Sync**: Fetches the shared `terraform-docs.yaml` configuration file from the governance repository
4. **Configuration Validation**: Compares the local and shared `terraform-docs.yaml` files to detect inconsistencies
5. **Documentation Validation**: Uses `terraform-docs` to validate the documentation and ensure it reflects the module's current configuration.

---

## **Module CI Code Analysis**
**File**: [`.github/workflows/module-ci-code-analysis.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-code-analysis.yaml)

### **Purpose**
The `module-ci-code-analysis` workflow scans Terraform configurations for misconfigurations and secrets using Trivy, a powerful security and configuration analysis tool.

### **Steps**
1. **Repository Checkout**: Clones the repository to analyze its contents
2. **Misconfiguration and Secret Scanning**: Uses Trivy to detect issues such as misconfigurations, exposed secrets, and other high-severity vulnerabilities

---

## **Module CI Test**
**File**: [`.github/workflows/module-ci-test.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-test.yaml)

### **Purpose**
This workflow runs Terraform tests in different environments (examples, local, and remote) to ensure that module configurations function as intended.

### **Steps**
1. **Repository Checkout**: Clones the repository for testing
2. **Fetch Terraform Version**: Identifies the Terraform version required for the tests
3. **Terraform Setup**: Installs and configures Terraform
4. **Example Tests**: Tests Terraform configurations under the `tests/examples` directory
5. **Local Tests**: Tests Terraform configurations under the `tests/local` directory
6. **Remote Tests**: Tests Terraform configurations under the `tests/remote` directory, including Azure authentication using OpenID Connect

---

## **Module CI Issue**
**File**: [`.github/workflows/module-ci-issue.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-ci-issue.yaml)

### **Purpose**
Automatically creates a GitHub issue if a scheduled workflow fails, providing visibility into workflow failures.

### **Steps**
1. **Issue Creation**: Uses the GitHub API to create an issue with a link to the failed workflow run and relevant details

### **Contributions**
We encourage contributions from the community. Whether you're reporting issues, suggesting enhancements, or contributing code, your input is highly valued. Refer to the [Contributing Guidelines](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-release.yaml) for details.
