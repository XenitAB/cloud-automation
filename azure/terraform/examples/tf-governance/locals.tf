locals {
  envResources = { for p in setproduct(var.rgConfig, var.regions) : "${var.environmentShort}-${p[1].locationShort}-${p[0].commonName}" => {
    name             = "${var.environmentShort}-${p[1].locationShort}-${p[0].commonName}"
    environmentShort = var.environmentShort
    rgConfig         = p[0]
    region           = p[1]
    }
  }
  coreRgs            = [for region in var.regions : "${var.environmentShort}-${region.locationShort}-${var.coreCommonName}"]
  groupNameSeparator = "-"
  aadGroupPrefix     = "az"
  spNamePrefix       = "sp"
  aksGroupNamePrefix = "aks"
}
