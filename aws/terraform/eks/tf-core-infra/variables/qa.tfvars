environment = "qa"
vpcConfig = {
  cidr_block           = "10.101.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  subnets = [
    {
      name       = "eks1"
      cidr_block = "10.101.0.0/19"
      az         = 0
      eksName    = "eks"
    },
    {
      name       = "eks2"
      cidr_block = "10.101.32.0/19"
      az         = 1
      eksName    = "eks"
    },
    {
      name       = "eks3"
      cidr_block = "10.101.64.0/19"
      az         = 2
      eksName    = "eks"
    }
  ]
}
