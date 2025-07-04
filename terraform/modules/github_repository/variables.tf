variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

variable "actions_secrets" {
  description = "GitHub Actions environment secrets to create."
  type        = map(string)
  default     = {}
  sensitive   = true
}
