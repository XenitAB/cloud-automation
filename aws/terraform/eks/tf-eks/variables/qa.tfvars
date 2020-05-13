environment = "qa"
dnsZone     = "qa.xenit.io"
eksConfiguration = {
  kubernetesVersion = "1.15"
  nodeGroups = [
    {
      name      = "default"
      min_size  = 2
      max_size  = 4
      disk_size = 128
      instance_types = [
        "t3.medium"
      ]
    }
  ]
}
