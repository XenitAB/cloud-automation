environmentShort = "prod"

aksConfiguration = {
  kubernetes_version = "1.16.9"
  sku_tier           = "Free"
  default_node_pool = {
    orchestrator_version = "1.16.9"
    vm_size              = "Standard_F2s_v2"
    min_count            = 1
    max_count            = 1
    node_labels          = {}
  },
  additional_node_pools = []
}

azure_pipelines_agent = {
  helm_chart_name    = "azure-pipelines-agent"
  helm_chart_version = "0.1.5"
  helm_chart_repo    = "https://xenitab.github.io/azure-pipelines-agent"
  namespace          = "azure-pipelines-agent"
  replicas           = 2
  pool_name_prefix   = "aks-"
  azdo_organization  = "xenitab"
}
