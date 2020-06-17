locals {
  envResources = { for region in var.regions : "${var.environmentShort}-${region.locationShort}-${var.commonName}" => {
    name             = "${var.environmentShort}-${region.locationShort}-${var.commonName}"
    environmentShort = var.environmentShort
    region           = region
    vnetConfig       = var.vnetConfig[region.locationShort]
    }
  }

  subnets = flatten([
    for region, vnet in var.vnetConfig : [
      for subnet in vnet.subnets : {
        vnet_region              = region
        vnet_resource            = "${var.environmentShort}-${region}-${var.commonName}"
        subnet_full_name         = "sn-${var.environmentShort}-${region}-${var.commonName}-${subnet.name}"
        subnet_short_name        = subnet.name
        subnet_cidr              = subnet.cidr
        subnet_service_endpoints = subnet.service_endpoints
        subnet_aksSubnet         = subnet.aksSubnet
      }
    ]
  ])

  groupNameSeparator = "-"
  aadGroupPrefix     = "az"
}
