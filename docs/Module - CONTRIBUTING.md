# Contribution Guide for Terraform Modules

Thank you for considering contributing to our open-source Terraform modules! We
welcome all contributions to help improve our modules and make them more robust.

When contributing to this repository, please first discuss the change you
wish to make via an issue, an email, or any other method with the owners of
this repository before making a change.

Please note we have a code of conduct. Please follow it in all your
interactions with the project.


## How to Contribute

### 1. Reporting Issues

If you encounter any bugs, issues, or have suggestions for improvements, please
open an issue in the repository. Provide as much detail as possible to help us
understand and reproduce the issue.

### 2. Submitting a Pull Request

We welcome pull requests for improvements. To ensure a smooth process, please:

1. **Make Changes**: Implement your changes in the appropriate subdirectory. Ensure each action has a clear and comprehensive README file.
   - Update the [README.md](../README.md) file with details about your changes
     and regenerate the Terraform documentation.
     ```bash
     terraform-docs . --config .terraform-docs.yaml
     ```
   - Update examples in the [examples](../examples) directory and the
   [CHANGELOG.md](../CHANGELOG.md) to reflect your changes.
2. **Sign Your Work**: Before committing your changes, ensure each commit message
   includes a `Signed-off-by` line.
3. **Commit Changes**: Commit your changes with a meaningful commit message.
4. **Open a Pull Request**: Open a pull request from your forked repository.
5. **Describe Your Changes**: Provide a clear and concise description of the
   changes you've made in the pull request description. Include any relevant
   information that would help reviewers understand your contribution.
6. **Wait for Review**: Once you've submitted your pull request, our team will
   review your changes. We may ask for further clarification or suggest
   improvements.
7. **Address Feedback**: If any changes are requested, make the necessary
   adjustments to your branch and push the changes. The pull request will be
   automatically updated.
8. **Merge Pull Request**: Once your pull request has been approved, it will be
   merged into the main repository.  
   Congratulations on your contribution!

### 3. Code Style and Quality

- Ensure your code follows the repository's coding standards.
- Write clear and concise commit messages.
- Update documentation as necessary.

### 4. Reviewing and Feedback

We will review your pull request as soon as possible. Please be patient and
responsive to any feedback or requested changes.

### 5. Community Guidelines

Be respectful and considerate in all interactions. We value contributions from
everyone and aim to create a welcoming and inclusive environment.


## Need Help?

If you have any questions or need assistance with contributing, don't hesitate to reach out to us. We're here to help and guide you through the process.

Thank you for contributing to our Terraform modules! We appreciate your support and contributions.
