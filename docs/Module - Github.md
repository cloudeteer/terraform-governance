## Module - GitHub
 File : [`.github/workflows/module-github.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github.yaml)

### Purpose
The `module-manage-github` workflow serves as an entry point for GitHub management tasks. It calls modular workflows for managing GitHub projects, handling pull requests, and automating releases.

### Triggers
This workflow is triggered using `workflow_call`, allowing other workflows to invoke it with specific inputs.

### Inputs 
-  `run_job_project` :  
  Description: Determines whether to run the project management job  
  Type: `boolean`  
  Default: `true`

### Jobs 
1.  Project Management :
    - Executes the [`module-github-project.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github.yaml) workflow
    - Runs when:
        - `run_job_project` is `true`, and
        - The event is a pull request or issue
2.  Pull Request Management :
    - Executes the [`module-github-pull-request.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-pull-request.yaml) workflow
    - Runs for pull request events
3.  Release Automation :
    - Executes the [`module-github-release.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-release.yaml) workflow
    - Runs when:
        - The event is a push to the `main` branch

---

## Module GitHub Project 
 File : [`.github/workflows/module-github-project.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-project.yaml)

### Purpose 
This workflow automates the management of GitHub projects by interacting with a specific project URL.

### Steps 
1.  Run Project Management :
    - Uses the `cloudeteer/actions/manage-github-project@main` action to manage a predefined GitHub project
    - Configurations:
        -  Project URL : Specifies the project to manage
        -  App ID : Identifies the GitHub App for authentication
        -  Private Key : Provides the app's private key for secure access

---

## Module GitHub Pull Request 
 File : [`.github/workflows/module-github-pull-request.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-pull-request.yaml)

### Purpose 
The `module-ci-pull-request` workflow ensures pull requests have exactly one required label, enforcing labeling best practices.

### Steps 
1.  Check Required Labels :
    - Uses the `mheap/github-action-required-labels@v5` action
    - Enforces that each pull request must have exactly one of the following labels:
        - `breaking-change`
        - `feature`
        - `fix`
        - `other`
        - `ignore-release`

---

## Module GitHub Release 
 File : [`.github/workflows/module-github-release.yaml`](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-release.yaml)

### Purpose 
Automates semantic versioning and GitHub releases based on pull request labels.

### Steps 
1.  Checkout Code :
    - Fetches the repository code, including all tags
2.  Calculate SemVer Tag :
    - Determines the next semantic version based on pull request labels:
        - `breaking-change`: Bumps the major version
        - `feature`: Bumps the minor version
        - No special labels: Bumps the patch version
3.  Push Tag :
    - Creates and pushes a new Git tag
    - Skips tagging if the latest tag matches the current commit
4.  Create Release :
    - Uses the GitHub CLI to generate a release with auto-generated release notes

---

### Contributions 
We encourage contributions from the community. Whether you're reporting issues, suggesting enhancements, or contributing code, your input is highly valued. Refer to the [Contributing Guidelines](https://github.com/cloudeteer/terraform-governance/blob/main/.github/workflows/module-github-release.yaml) for details.
