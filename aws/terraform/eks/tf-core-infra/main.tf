# Configure backend
terraform {
  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "eu-north-1"
}
