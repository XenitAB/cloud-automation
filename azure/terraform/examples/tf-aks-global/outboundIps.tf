resource "azurerm_public_ip_prefix" "aks" {
  count               = 2
  name                = "pip-prefix-${var.environmentShort}-${var.locationShort}-${var.aksCommonName}-aks-${count.index}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  prefix_length       = 29
  sku                 = "Standard"
}

resource "azurerm_public_ip_prefix" "azp" {
  count               = 2
  name                = "pip-prefix-${var.environmentShort}-${var.locationShort}-${var.aksCommonName}-azp-${count.index}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  prefix_length       = 29
  sku                 = "Standard"
}
