variable "github_token" {
  description = "GitHub token to manage repositories"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_repos" {
  description = "List of repositories to create"
  type        = list(string)
  default     = []
}
