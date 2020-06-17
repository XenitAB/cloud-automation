locals {
  envResources = [for region in var.regions : "${var.environmentShort}-${region.locationShort}-${var.coreCommonName}"]
  spNamePrefix = "sp"
}
