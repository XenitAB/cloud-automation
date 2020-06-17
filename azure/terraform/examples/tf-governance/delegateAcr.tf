resource "azuread_group" "aadGroupAcrPush" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}acrpush"
}

resource "azuread_group" "aadGroupAcrPull" {
  name = "${local.aksGroupNamePrefix}${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}acrpull"
}

resource "azuread_group_member" "aadGroupMemberAcrSpn" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateAks == true
  }
  group_object_id  = azuread_group.aadGroupAcrPush.id
  member_object_id = azuread_service_principal.aadSp[each.key].object_id
}

resource "azuread_group_member" "aadGroupMemberAcrOwner" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateAks == true
  }
  group_object_id  = azuread_group.aadGroupAcrPush.id
  member_object_id = azuread_group.aadGroupRgOwner[each.key].id
}

resource "azuread_group_member" "aadGroupMemberAcrContributor" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateAks == true
  }
  group_object_id  = azuread_group.aadGroupAcrPush.id
  member_object_id = azuread_group.aadGroupRgContributor[each.key].id
}

resource "azuread_group_member" "aadGroupMemberAcrReader" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateAks == true
  }
  group_object_id  = azuread_group.aadGroupAcrPull.id
  member_object_id = azuread_group.aadGroupRgReader[each.key].id
}
