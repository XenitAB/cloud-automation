resource "azurerm_key_vault" "delegateKv" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  name                = "kv-${each.value.name}"
  location            = azurerm_resource_group.rg[each.value.name].location
  resource_group_name = azurerm_resource_group.rg[each.value.name].name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "delegateKvApOwnerSpn" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azuread_service_principal.ownerSpn.id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApRgAadGroup" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.aadGroupRgContributor[each.value.rgConfig.commonName].id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApRgSp" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if(envResource.rgConfig.delegateKv == true && envResource.rgConfig.delegateSp == true)
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.aadSp[each.value.rgConfig.commonName].object_id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApKvreaderSp" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_service_principal.delegateKvAadSp[each.value.rgConfig.commonName].object_id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApSubAadGroupOwner" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.aadGroupSubOwner.id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}

resource "azurerm_key_vault_access_policy" "delegateKvApSubAadGroupContributor" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateKv == true
  }

  key_vault_id       = azurerm_key_vault.delegateKv[each.value.name].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azuread_group.aadGroupSubContributor.id
  key_permissions    = var.kvDefaultPermissions.key_permissions
  secret_permissions = var.kvDefaultPermissions.secret_permissions
}
