resource "aws_subnet" "subnet" {
  for_each = {
    for subnet in var.vpcConfig.subnets :
    subnet.name => subnet
    if subnet.eksName == ""
  }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
  }
}

resource "aws_subnet" "subnetEks" {
  for_each = {
    for subnet in var.vpcConfig.subnets :
    subnet.name => subnet
    if subnet.eksName != ""
  }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[each.value.az]
  map_public_ip_on_launch = true


  tags = {
    Name                                                                                                        = "subnet-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.name}"
    "kubernetes.io/cluster/eks-${var.environment}-${var.locationShort}-${var.commonName}-${each.value.eksName}" = "shared"
  }
}
