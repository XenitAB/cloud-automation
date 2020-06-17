resource "azurerm_role_definition" "roleServiceEndpointJoin" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  name  = "role-${each.value.name}-serviceEndpointJoin"
  scope = azurerm_virtual_network.vnet[each.value.name].id

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/subnets/joinViaServiceEndpoint/action"]
    not_actions = []
  }

  assignable_scopes = [
    azurerm_virtual_network.vnet[each.value.name].id
  ]
}

data "azuread_group" "aadGroupServiceEndpointJoin" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}serviceEndpointJoin"
}

resource "azurerm_role_assignment" "assignmentServiceEndpointJoin" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  scope              = azurerm_virtual_network.vnet[each.value.name].id
  role_definition_id = azurerm_role_definition.roleServiceEndpointJoin[each.value.name].id
  principal_id       = data.azuread_group.aadGroupServiceEndpointJoin.id
}
