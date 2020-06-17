data "azurerm_key_vault" "coreKv" {
  name                = "kv-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
  resource_group_name = "rg-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
}

data "azurerm_key_vault_secret" "kvSecretAzureDevOpsPAT" {
  name         = "azure-devops-pat"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}
