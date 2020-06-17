resource "azurerm_frontdoor" "afd" {
  name                                         = "afd-${var.environmentShort}-${var.locationShort}-${var.subscriptionCommonName}"
  resource_group_name                          = data.azurerm_resource_group.rg.name
  enforce_backend_pools_certificate_name_check = true

  frontend_endpoint {
    name                              = "afd-fe-default"
    host_name                         = "afd-${var.environmentShort}-${var.locationShort}-${var.subscriptionCommonName}.azurefd.net"
    custom_https_provisioning_enabled = false
  }

  backend_pool_load_balancing {
    name = "afd-lb"
  }

  backend_pool_health_probe {
    name         = "afd-hp"
    path         = "/"
    protocol     = "Https"
    probe_method = "HEAD"
  }

  backend_pool {
    name = "afd-be-aks1-site"
    backend {
      host_header = "aks1.tflab-dev.xenit.io"
      address     = "aks1.tflab-dev.xenit.io"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "afd-lb"
    health_probe_name   = "afd-hp"
  }

  routing_rule {
    name               = "afd-rt-site"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["afd-fe-default"]
    forwarding_configuration {
      forwarding_protocol = "HttpsOnly"
      backend_pool_name   = "afd-be-aks1-site"
    }
  }








}
