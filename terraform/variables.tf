variable "create_repo" {
  description = "A repository name to create"
  type        = string
  default     = ""
}

variable "actions_secrets" {
  description = "GitHub Actions environment secrets to create."
  type        = map(string)
  default     = {}
}

variable "ARM_CLIENT_ID" {
  description = "The Client ID of the Azure managed identity utilized for authentication during test deployments."
  type        = string
  sensitive   = true
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "The Subscription ID of the Azure managed identity utilized for authentication during test deployments."
  type        = string
  sensitive   = true

}

variable "ARM_TENANT_ID" {
  description = "The Tenant ID of the Azure managed identity utilized for authentication during test deployments."
  sensitive   = true
  type        = string
}
