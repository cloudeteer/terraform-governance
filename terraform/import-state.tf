# How to import a state:
# 1. add topics "terraform-module,auto-terraform-governance" to repository
# 2. add collaborator "cloudeteerbot" with admin permission to repository
# 3. add import entry for repository here
# 4. commit and run module-repo-setup action

import {
  id = "terraform-test-createnew3"
  to = module.github_repository["terraform-test-createnew3"].github_repository.repository
}
