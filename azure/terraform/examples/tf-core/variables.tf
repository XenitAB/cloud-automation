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
  description = "The subscriptionCommonName to use for the deploy"
  type        = string
}

variable "commonName" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "vnetConfig" {
  description = "Address spaces used by virtual network."
  type = map(object({
    addressSpace = list(string)
    subnets = list(object({
      name              = string
      cidr              = string
      service_endpoints = list(string)
      aksSubnet         = bool
    }))
  }))
}
