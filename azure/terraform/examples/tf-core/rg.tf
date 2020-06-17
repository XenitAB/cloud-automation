# Add datasource for resource group
data "azurerm_resource_group" "rg" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  name = "rg-${each.value.name}"
}
