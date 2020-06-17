# AAD Group for Subscription Owners
resource "azuread_group" "aadGroupSubOwner" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}owner"
}

resource "azurerm_role_assignment" "roleAssignmentSubOwner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.aadGroupSubOwner.id
}

# AAD Group for Subscription Contributors
resource "azuread_group" "aadGroupSubContributor" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}contributor"
}

resource "azurerm_role_assignment" "roleAssignmentSubContributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.aadGroupSubContributor.id
}

# AAD Group for Subscription Readers
resource "azuread_group" "aadGroupSubReader" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}reader"
}

resource "azurerm_role_assignment" "roleAssignmentSubReader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.aadGroupSubReader.id
}
