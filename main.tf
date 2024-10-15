resource "azurerm_container_registry" "credifyai" {
  name                = "credifyai"
  resource_group_name = azurerm_resource_group.credifyai.name
  location            = azurerm_resource_group.credifyai.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azuredevops_project" "credifyai" {
  name       = "credifyai"
  visibility = "private"
}

resource "azuredevops_serviceendpoint_azurerm" "azurerm" {
  project_id                             = azuredevops_project.credifyai.id
  service_endpoint_name                  = "azurerm"
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = var.client_id
    serviceprincipalkey = var.client_secret
  }

  azurerm_spn_tenantid      = var.tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = "AzureRM Subscription"
}

resource "azuredevops_serviceendpoint_github" "github" {
  project_id            = azuredevops_project.credifyai.id
  service_endpoint_name = "github"
  auth_personal {
    personal_access_token = var.github_pat
  }
}

resource "azuredevops_serviceendpoint_azurecr" "acr" {
  project_id                = azuredevops_project.credifyai.id
  service_endpoint_name     = "acr"
  resource_group            = azurerm_resource_group.credifyai.name
  azurecr_spn_tenantid      = var.tenant_id
  azurecr_name              = "credifyai"
  azurecr_subscription_id   = var.subscription_id
  azurecr_subscription_name = "ACR Subscription"
}

resource "azuredevops_resource_authorization" "azurerm" {
  project_id  = azuredevops_project.credifyai.id
  resource_id = azuredevops_serviceendpoint_azurerm.azurerm.id
  authorized  = true
}

resource "azuredevops_resource_authorization" "acr" {
  project_id  = azuredevops_project.credifyai.id
  resource_id = azuredevops_serviceendpoint_azurecr.acr.id
  authorized  = true
}

resource "azuredevops_build_definition" "frontend" {
  project_id = azuredevops_project.credifyai.id
  name       = "frontend"
  path       = "\\"

  repository {
    repo_type             = "GitHub"
    repo_id               = "CredifyAI/frontend"
    github_enterprise_url = "https://github.com"
    branch_name           = "main"
    service_connection_id = azuredevops_serviceendpoint_github.github.id
    yml_path              = "azure.yml"
  }

  ci_trigger {
    use_yaml = true
  }
}

