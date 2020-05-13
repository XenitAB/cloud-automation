resource "aws_route_table" "rtDefault" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-${var.environment}-${var.locationShort}-${var.commonName}-default"
  }
}

resource "aws_route_table_association" "rtAssociationSubnet" {
  for_each = {
    for subnet in var.vpcConfig.subnets :
    subnet.name => subnet
    if subnet.eksName == ""
  }

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rtDefault.id
}

resource "aws_route_table_association" "rtAssociationSubnetEks" {
  for_each = {
    for subnet in var.vpcConfig.subnets :
    subnet.name => subnet
    if subnet.eksName != ""
  }

  subnet_id      = aws_subnet.subnetEks[each.key].id
  route_table_id = aws_route_table.rtDefault.id
}
