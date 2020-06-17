data "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
  resource_group_name = "rg-${var.environmentShort}-${var.locationShort}-${var.coreCommonName}"
}

resource "azurerm_role_assignment" "vnetAssignment" {
  scope                = data.azurerm_virtual_network.vnet.id
  role_definition_name = "Contributor"
  principal_id         = local.aksAadApps.aksClientAppPrincipalId
}
