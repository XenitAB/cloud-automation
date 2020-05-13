variable "commonName" {
  description = "Common name for the environment"
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

variable "vpcConfig" {
  description = "The configuration of the VPC"
  type = object({
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    subnets = list(object({
      name       = string
      cidr_block = string
      az         = number
      eksName    = string
    }))
  })
}
