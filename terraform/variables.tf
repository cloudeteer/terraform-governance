variable "github_token" {
  description = "GitHub token to manage repositories"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_repo" {
  description = "A repository name to create"
  type        = string
  default     = ""
}
