# Configure backend
terraform {
  backend "azurerm" {}
}

# Configure the Azure Provider
provider "azurerm" {
  version = "=2.14.0"
  features {}
}

# Configure the Azure AD Provider
provider "azuread" {
  version = "=0.10.0"
}
