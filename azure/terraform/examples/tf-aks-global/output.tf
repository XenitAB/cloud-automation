output "aadGroups" {
  value = {
    aadGroupView         = azuread_group.aadGroupView
    aadGroupEdit         = azuread_group.aadGroupEdit
    aadGroupClusterAdmin = azuread_group.aadGroupClusterAdmin
    aadGroupClusterView  = azuread_group.aadGroupClusterView
  }
}

output "aadPodIdentity" {
  value = azurerm_user_assigned_identity.userAssignedIdentityNs
}

output "acr" {
  value = azurerm_container_registry.acr
}

output "k8sNamespaces" {
  value = var.k8sNamespaces
}

output "aksAuthorizedIps" {
  value = concat(
    var.aksAuthorizedIps,
    local.aksPipPrefixes,
    local.azpPipPrefixes
  )
}

output "aksPipPrefixes" {
  value = azurerm_public_ip_prefix.aks
}

output "azpPipPrefixes" {
  value = azurerm_public_ip_prefix.azp
}
