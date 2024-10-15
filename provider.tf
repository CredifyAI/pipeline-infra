terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.5.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "1.3.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
  subscription_id = var.subscription_id
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/credifyai"
  personal_access_token = var.azure_devops_pat
}