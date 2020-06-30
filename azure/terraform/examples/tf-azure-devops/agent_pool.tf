resource "azuredevops_agent_pool" "aks" {
  name           = "aks-${var.environmentShort}"
  auto_provision = false
}

