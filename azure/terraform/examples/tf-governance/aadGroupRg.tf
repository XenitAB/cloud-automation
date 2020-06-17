# AAD Group for Resource Group Owners
resource "azuread_group" "aadGroupRgOwner" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}owner"
}

resource "azurerm_role_assignment" "roleAssignmentRgOwner" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Owner"
  principal_id         = azuread_group.aadGroupRgOwner[each.value.rgConfig.commonName].id
}

# AAD Group for Resource Group Contributors
resource "azuread_group" "aadGroupRgContributor" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}contributor"
}

resource "azurerm_role_assignment" "roleAssignmentRgContributor" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.aadGroupRgContributor[each.value.rgConfig.commonName].id
}

# AAD Group for Resource Group Readers
resource "azuread_group" "aadGroupRgReader" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
  }

  name = "${local.aadGroupPrefix}${local.groupNameSeparator}rg${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}${each.value.commonName}${local.groupNameSeparator}reader"
}

resource "azurerm_role_assignment" "roleAssignmentRgReader" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  scope                = azurerm_resource_group.rg[each.value.name].id
  role_definition_name = "Reader"
  principal_id         = azuread_group.aadGroupRgReader[each.value.rgConfig.commonName].id
}
