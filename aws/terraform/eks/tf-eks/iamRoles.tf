# EKS Cluster
resource "aws_iam_role" "iamRoleEksCluster" {
  name = "iam-role-eks-${var.environment}-${var.locationShort}-${var.commonName}-cluster"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# EKS Node Group
resource "aws_iam_role" "iamRoleEksNodeGroup" {
  name = "iam-role-eks-${var.environment}-${var.locationShort}-${var.commonName}-nodegroup"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}
