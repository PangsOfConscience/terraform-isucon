variable "region" {
  default     = "ap-northeast-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "isucon_vpc"
  cidr                 = "172.16.0.0/16"
  azs                  = ["ap-northeast-1d"]
  public_subnets       = ["172.16.10.0/24"]
  private_subnets      = ["172.16.11.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "isucon-training"
  }
}
