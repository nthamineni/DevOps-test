################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = "test-Vpc"
  cidr = "50.0.0.0/16"


  azs = ["us-east-1a", "us-east-1b" ]

  private_subnets = ["50.0.128.0/20" ]
  public_subnets  = ["50.0.0.0/20" ]

  enable_nat_gateway = true


  tags = {
    Terraform   = "true"
    Environment = "test"
  }
}