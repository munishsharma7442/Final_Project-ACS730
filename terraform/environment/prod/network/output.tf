
# Print public_subnet_ids
output "public_subnet_ids" {
  value = module.vpc-prod.public_subnet_ids
}

# Print Private subnet in production env
output "private_subnet_ids" {
  value = module.vpc-prod.private_subnet_ids
}

# Print Public subnet in production env
output "vpc_id" {
  value = module.vpc-prod.vpc_id
}
