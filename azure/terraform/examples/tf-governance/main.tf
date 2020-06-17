# Configure backend
terraform {
  backend "azurerm" {}
}

# Configure the Azure Provider
provider "azurerm" {
  version = "=2.14.0"
  features {}
}

provider "azuread" {
  version = "=0.10.0"
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
