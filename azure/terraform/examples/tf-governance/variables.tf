variable "regions" {
  description = "The Azure Regions to configure"
  type = list(object({
    location      = string
    locationShort = string
  }))
}

variable "environmentShort" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "subscriptionCommonName" {
  description = "The commonName for the subscription"
  type        = string
}

variable "coreCommonName" {
  description = "The commonName for the core infra"
  type        = string
}

variable "partner_id" {
  description = "The partner id used for service principals (PAL - Partner Admin Link)"
  type        = string
}

variable "rgConfig" {
  description = "Resource group configuration"
  type = list(
    object({
      commonName  = string
      delegateAks = bool # Delegate aks permissions
      delegateKv  = bool # Delegate KeyVault creation
      delegateSe  = bool # Delegate Service Endpoint permissions
      delegateSp  = bool # Delegate Service Principal
      tags        = map(string)
    })
  )
}

variable "kvDefaultPermissions" {
  description = "Default permissions for key vault"
  type = object({
    key_permissions    = list(string)
    secret_permissions = list(string)
  })
}

variable "ownerServicePrincipalName" {
  description = "The name of the service principal that will be used to run terraform and is owner of the subsciptions"
  type        = string
}
