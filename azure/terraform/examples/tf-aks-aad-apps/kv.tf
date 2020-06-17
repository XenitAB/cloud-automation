data "azurerm_key_vault" "coreKv" {
  for_each = {
    for envResource in local.envResources :
    envResource => envResource
  }

  name                = "kv-${each.key}"
  resource_group_name = "rg-${each.key}"
}
