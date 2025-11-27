terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.12.1"
}

provider "azurerm" {
  features {}
  subscription_id = "<subscription-id>"
}

provider "azuread" {
  tenant_id = "<tenant-id>"
}

provider "random" {}
