# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  name                = "vnet-${each.value.name}"
  resource_group_name = data.azurerm_resource_group.rg[each.value.name].name
  location            = data.azurerm_resource_group.rg[each.value.name].location
  address_space       = each.value.vnetConfig.addressSpace
}
