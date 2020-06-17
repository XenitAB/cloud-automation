locals {
  spNamePrefix       = "sp"
  groupNameSeparator = "-"
  aadGroupPrefix     = "az"
  aksGroupNamePrefix = "aks"
  aksAadApps = {
    aksClientAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientId
    aksClientAppPrincipalId  = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppPrincipalId
    aksClientAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksClientAppClientSecret
    aksServerAppClientId     = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientId
    aksServerAppClientSecret = jsondecode(data.azurerm_key_vault_secret.kvSecretAadApps.value).aksServerAppClientSecret
  }
}
