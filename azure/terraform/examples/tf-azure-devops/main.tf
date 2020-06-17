# Configure backend
terraform {
  backend "azurerm" {}
}

# Configure the Azure Provider
provider "azurerm" {
  version = "=2.14.0"
  features {}
}

# Configure the Azure Provider
provider "azuredevops" {
  version               = "=0.1.3"
  org_service_url       = var.azureDevOpsUri
  personal_access_token = data.azurerm_key_vault_secret.kvSecretAzureDevOpsPAT.value
}

data "azurerm_subscription" "current" {}
