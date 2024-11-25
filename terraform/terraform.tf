terraform {
  required_version = "~> 1.8.4"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.1"
    }
  }
}
