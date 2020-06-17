resource "azuread_group" "aadGroupServiceEndpointJoin" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}${var.environmentShort}${local.groupNameSeparator}serviceEndpointJoin"
}

resource "azuread_group_member" "aadGroupMemberServiceEndpointJoinSpn" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSe == true
  }
  group_object_id  = azuread_group.aadGroupServiceEndpointJoin.id
  member_object_id = azuread_service_principal.aadSp[each.key].object_id
}

resource "azuread_group_member" "aadGroupMemberServiceEndpointJoinOwner" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSe == true
  }
  group_object_id  = azuread_group.aadGroupServiceEndpointJoin.id
  member_object_id = azuread_group.aadGroupRgOwner[each.key].id
}

resource "azuread_group_member" "aadGroupMemberServiceEndpointJoinContributor" {
  for_each = {
    for rg in var.rgConfig :
    rg.commonName => rg
    if rg.delegateSe == true
  }
  group_object_id  = azuread_group.aadGroupServiceEndpointJoin.id
  member_object_id = azuread_group.aadGroupRgContributor[each.key].id
}
