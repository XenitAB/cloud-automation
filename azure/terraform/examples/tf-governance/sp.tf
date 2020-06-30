data "azuread_service_principal" "ownerSpn" {
  display_name = var.ownerServicePrincipalName
}

resource "azuread_application" "aadApp" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSp == true
  }

  name = "${local.spNamePrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}contributor"
}

resource "azuread_service_principal" "aadSp" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSp == true
  }

  application_id = azuread_application.aadApp[each.key].application_id
}

resource "azurerm_role_assignment" "roleAssignmentSp" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
    if envResource.rgConfig.delegateSp == true
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aadSp[each.value.rgConfig.commonName].object_id
}

resource "random_password" "aadSpSecret" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSp == true
  }
  length           = 48
  special          = true
  override_special = "!-_="

  keepers = {
    service_principal = azuread_service_principal.aadSp[each.key].id
  }
}

resource "azuread_application_password" "aadSpSecret" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSp == true
  }
  application_object_id = azuread_application.aadApp[each.key].id
  value                 = random_password.aadSpSecret[each.key].result
  end_date              = timeadd(timestamp(), "87600h") # 10 years

  lifecycle {
    ignore_changes = [
      end_date
    ]
  }
}

resource "pal_management_partner" "rg_service_principal" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSp == true
  }

  tenant_id     = data.azurerm_client_config.current.tenant_id
  client_id     = azuread_service_principal.aadSp[each.key].application_id
  client_secret = random_password.aadSpSecret[each.key].result
  partner_id    = var.partner_id
}

resource "azurerm_key_vault_secret" "aadSpKvSecret" {
  for_each = {
    for envResourceCoreRg in setproduct(var.rgConfig, local.coreRgs) : "${envResourceCoreRg[1]}-${envResourceCoreRg[0].commonName}" => {
      rgConfig = envResourceCoreRg[0]
      coreRg   = envResourceCoreRg[1]
    }
    if envResourceCoreRg[0].delegateSp == true
  }

  name = replace(azuread_service_principal.aadSp[each.value.rgConfig.commonName].display_name, ".", "-")
  value = jsonencode({
    tenantId       = data.azurerm_subscription.current.tenant_id
    subscriptionId = data.azurerm_subscription.current.subscription_id
    clientId       = azuread_service_principal.aadSp[each.value.rgConfig.commonName].application_id
    clientSecret   = random_password.aadSpSecret[each.value.rgConfig.commonName].result
  })
  key_vault_id = azurerm_key_vault.delegateKv[each.value.coreRg].id

  depends_on = [
    azurerm_key_vault_access_policy.delegateKvApOwnerSpn
  ]
}
