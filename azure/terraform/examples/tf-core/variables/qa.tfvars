environmentShort = "qa"
vnetConfig = {
  we = {
    addressSpace = ["10.2.0.0/16"]
    subnets = [
      {
        name              = "aks1"
        cidr              = "10.2.0.0/24"
        service_endpoints = []
        aksSubnet         = true
      },
      {
        name              = "servers"
        cidr              = "10.2.1.0/24"
        service_endpoints = []
        aksSubnet         = false
      }
    ]
  }
}
