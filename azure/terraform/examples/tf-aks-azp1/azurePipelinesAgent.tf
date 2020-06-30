data "azurerm_key_vault_secret" "azure_pipelines_agent" {
  name         = "azure-pipelines-agent"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}

resource "kubernetes_namespace" "azure_pipelines_agent" {
  metadata {
    labels = {
      name = var.azure_pipelines_agent.namespace
    }
    name = var.azure_pipelines_agent.namespace
  }
}

resource "helm_release" "azure_pipelines_agent" {
  name       = var.azure_pipelines_agent.helm_chart_name
  repository = var.azure_pipelines_agent.helm_chart_repo
  chart      = var.azure_pipelines_agent.helm_chart_name
  version    = var.azure_pipelines_agent.helm_chart_version
  namespace  = var.azure_pipelines_agent.namespace

  set {
    name  = "replicaCount"
    value = var.azure_pipelines_agent.replicas
  }

  set {
    name  = "azpAgent.url"
    value = "https://dev.azure.com/${var.azure_pipelines_agent.azdo_organization}"
  }

  set {
    name  = "azpAgent.pool"
    value = "${var.azure_pipelines_agent.pool_name_prefix}${var.environmentShort}"
  }

  set_sensitive {
    name  = "azpAgent.token"
    value = data.azurerm_key_vault_secret.azure_pipelines_agent.value
  }

  depends_on = [
    kubernetes_namespace.azure_pipelines_agent
  ]
}
