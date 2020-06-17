environmentShort = "dev"
vnetConfig = {
  we = {
    addressSpace = ["10.0.0.0/16"]
    subnets = [
      {
        name              = "aks1"
        cidr              = "10.0.0.0/24"
        service_endpoints = []
        aksSubnet         = true
      },
      {
        name              = "servers"
        cidr              = "10.0.1.0/24"
        service_endpoints = []
        aksSubnet         = false
      }
    ]
  }
}
