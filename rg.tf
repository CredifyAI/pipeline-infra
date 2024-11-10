resource "azurerm_resource_group" "vault" {
  name     = "${var.prefix}-vault"
  location = "West US 2"
  tags = {
    service = "vault"
  }
}

resource "azurerm_resource_group" "credifyai" {
  name     = "${var.prefix}-resources"
  location = "Central US"
  tags = {
    app = "credifyai"
  }
}