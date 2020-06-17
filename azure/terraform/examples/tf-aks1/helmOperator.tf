data "azurerm_key_vault_secret" "kvSecretHelmOperator" {
  name         = "helm-operator"
  key_vault_id = data.azurerm_key_vault.coreKv.id
}

resource "helm_release" "helmOperator" {
  for_each = {
    for ns in local.k8sNamespaces :
    ns.name => ns
  }

  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  chart      = "helm-operator"
  version    = "1.1.0"
  namespace  = each.key

  set {
    name  = "allowNamespace"
    value = each.key
  }

  set {
    name  = "clusterRole.create"
    value = "false"
  }

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "configureRepositories.enable"
    value = "true"
  }

  set {
    name  = "configureRepositories.repositories[0].name"
    value = "AzureContainerRegistry"
  }

  set {
    name  = "configureRepositories.repositories[0].url"
    value = "https://${local.acr.name}.azurecr.io/helm/v1/repo/"
  }

  set {
    name  = "configureRepositories.repositories[0].username"
    value = local.helmOperator.client_id
  }

  set {
    name  = "configureRepositories.repositories[0].password"
    value = local.helmOperator.secret
  }

  depends_on = [
    kubernetes_namespace.k8sNs
  ]
}
