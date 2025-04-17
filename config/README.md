# Module Repository Configuration Files

This directory contains the default configuration files used for Terraform module repositories.

These files serve as the standard reference for GitHub Actions workflows during CI runs. Instead of relying on the configuration files present in the individual module repositories, the CI process uses the files from this directory to ensure consistent behavior across all modules.

> [!NOTE]
> The configuration files in each module repository are still relevant for local development and pre-commit usage, but **CI always uses the shared files from this directory** to enforce consistency.
