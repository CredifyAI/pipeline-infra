variable "prefix" {
  default = "credifyai"
}

resource "azurerm_resource_group" "credifyai" {
  name     = "${var.prefix}-resources"
  location = "Central US"
  tags = {
    app = "credifyai"
  }
}