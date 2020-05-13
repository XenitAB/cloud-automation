resource "aws_vpc" "vpc" {
  cidr_block           = var.vpcConfig.cidr_block
  enable_dns_support   = var.vpcConfig.enable_dns_support
  enable_dns_hostnames = var.vpcConfig.enable_dns_hostnames

  tags = {
    Name = "vpc-${var.environment}-${var.locationShort}-${var.commonName}"
  }
}
