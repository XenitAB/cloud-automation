variable "locationShort" {
  description = "The Azure region short name."
  type        = string
}

variable "environmentShort" {
  description = "The environment (short name) to use for the deploy"
  type        = string
}

variable "commonName" {
  description = "The commonName to use for the deploy"
  type        = string
}

variable "subscriptionCommonName" {
  description = "The commonName for the subscription"
  type        = string
}
