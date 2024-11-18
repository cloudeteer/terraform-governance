# Pre-Commit

## What is Pre-Commit
Pre-Commit is a powerful tool that helps developers make high-quality, consistent, and error-free code changes.
It integrates seamlessly into the development workflow, minimizes manual reviews,
and ensures that issues are detected early—long before they reach the production environment.


For more information visit https://pre-commit.com

## Should I use it?
In short: Yes!

Every Module-Repository has certain checks on a pull-request to prevent formatting and documentation errors.
By using pre-commit, all checks will be done locally and sometimes even be fixed automatacally, which increase productivity and decreas the hassel with
the pull-request checks.

## Installing
### Mac
`brew install pre-commit`  
Run this command in your local repository in which you want to use it:  
`pre-commit install`