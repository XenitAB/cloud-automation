# Configure backend
terraform {
  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

data "aws_iam_role" "iamRoleEksAdmin" {
  name = "iam-role-eks-admin"
}

provider "aws" {
  alias   = "eksAdminRole"
  version = "~> 2.0"
  region  = "eu-west-1"
  assume_role {
    role_arn = data.aws_iam_role.iamRoleEksAdmin.arn
  }
}
