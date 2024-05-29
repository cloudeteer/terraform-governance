%{ for name in split(", ", repository_names) ~}
import {
  id = "${name}"
  to = module.github_repository["${name}"].github_repository.repository
}

output "${name}_import" {
  value = module.github_repository["${name}"].github_repository.repository
}
%{ endfor ~}