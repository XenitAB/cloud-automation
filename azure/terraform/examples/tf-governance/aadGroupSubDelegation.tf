# Example: az-sub-<subName>-all-owner
data "azuread_group" "aadGroupAllOwner" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}all${local.groupNameSeparator}owner"
}

resource "azuread_group_member" "aadGroupMemberSubAllOwner" {
  group_object_id  = azuread_group.aadGroupSubOwner.object_id
  member_object_id = data.azuread_group.aadGroupAllOwner.object_id
}

# Example: az-sub-<subName>-all-contributor
data "azuread_group" "aadGroupAllContributor" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}all${local.groupNameSeparator}contributor"
}

resource "azuread_group_member" "aadGroupMemberSubAllContributor" {
  group_object_id  = azuread_group.aadGroupSubContributor.object_id
  member_object_id = data.azuread_group.aadGroupAllContributor.object_id
}

# Example: az-sub-<subName>-all-reader
data "azuread_group" "aadGroupAllReader" {
  name = "${local.aadGroupPrefix}${local.groupNameSeparator}sub${local.groupNameSeparator}${var.subscriptionCommonName}${local.groupNameSeparator}all${local.groupNameSeparator}reader"
}

resource "azuread_group_member" "aadGroupMemberSubAllReader" {
  group_object_id  = azuread_group.aadGroupSubReader.object_id
  member_object_id = data.azuread_group.aadGroupAllReader.object_id
}
