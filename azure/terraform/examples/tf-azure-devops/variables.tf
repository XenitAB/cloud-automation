variable "locationShort" {
  description = "The Azure region short name."
  type        = string
}

variable "environmentShort" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "aksCommonName" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "coreCommonName" {
  description = "The commonName for the core infrastructure"
  type        = string
}

variable "azureDevOpsUri" {
  description = "The uri for Azure DevOps (https://dev.azure.com/<name>)"
  type        = string
}
