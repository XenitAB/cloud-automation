data "azuredevops_project" "site" {
  project_name = "site"
}

data "azurerm_key_vault_secret" "kvSecretContributor" {
  name         = "sp-rg-aks-${var.environmentShort}-site-contributor"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}


resource "azuredevops_serviceendpoint_azurerm" "siteContributor" {
  project_id            = data.azuredevops_project.site.id
  service_endpoint_name = "azure-${var.environmentShort}-site-contributor"
  credentials {
    serviceprincipalid  = jsondecode(data.azurerm_key_vault_secret.kvSecretContributor.value).clientId
    serviceprincipalkey = jsondecode(data.azurerm_key_vault_secret.kvSecretContributor.value).clientSecret
  }
  azurerm_spn_tenantid      = data.azurerm_subscription.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}
