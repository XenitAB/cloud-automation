resource "azurerm_resource_group" "rg" {
  for_each = {
    for envResource in local.envResources :
    envResource.name => envResource
  }

  name     = "rg-${each.value.name}"
  location = each.value.region.location
  tags = merge(
    {
      "Environment"   = each.value.environmentShort,
      "Location"      = each.value.region.location,
      "LocationShort" = each.value.region.locationShort

    },
    each.value.rgConfig.tags
  )
}
