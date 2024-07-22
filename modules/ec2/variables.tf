################################################################################
# Variables from other Modules
################################################################################

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "vpc_cidr_block" {
  description = "VPC cidr"
  type        = string
}

variable "public_subnets" {
  description = "VPC public_subnets"
  type        = list(any)
}

################################################################################
# Variables for ec2 Module
################################################################################
