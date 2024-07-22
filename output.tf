################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}


output "public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnets
}

################################################################################
# EC2 
################################################################################
