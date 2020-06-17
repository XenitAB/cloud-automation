regions = [
  {
    location      = "West Europe"
    locationShort = "we"
  }
]

subscriptionCommonName    = "tflab"
coreCommonName            = "core"
ownerServicePrincipalName = "sp-sub-tflab-all-owner"

kvDefaultPermissions = {
  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey"
  ]
  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]
}

rgConfig = [
  {
    commonName  = "core",
    delegateAks = false,
    delegateKv  = true,
    delegateSe  = false,
    delegateSp  = false,
    tags = {
      "description" = "Core infrastructure"
    }
  },
  {
    commonName  = "aks",
    delegateAks = false,
    delegateKv  = false,
    delegateSe  = false,
    delegateSp  = false,
    tags = {
      "description" = "Azure Kubernetes Service (AKS)"
    }
  },
  {
    commonName  = "afd",
    delegateAks = false,
    delegateKv  = false,
    delegateSe  = false,
    delegateSp  = false,
    tags = {
      "description" = "AFD - Azure Front Door"
    }
  },
  {
    commonName  = "site",
    delegateAks = true,
    delegateKv  = true,
    delegateSe  = true,
    delegateSp  = true,
    tags = {
      "description" = "Resources for site"
    }
  }
]
