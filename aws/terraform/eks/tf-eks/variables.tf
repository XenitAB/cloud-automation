variable "commonName" {
  description = "Common name for the environment"
  type        = string
}

variable "coreInfraCommonName" {
  description = "The core infrastructure common name for the environment"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "locationShort" {
  description = "The short name of the location"
  type        = string
}

variable "location" {
  description = "The sname of the location"
  type        = string
}

variable "eksConfiguration" {
  description = "The EKS Config"
  type = object({
    kubernetesVersion = string
    nodeGroups = list(object({
      name           = string
      min_size       = number
      max_size       = number
      disk_size      = number
      instance_types = list(string)
    }))
  })
}

variable "dnsZone" {
  description = "The DNS Zone that will be used by the EKS cluster"
  type        = string
}
