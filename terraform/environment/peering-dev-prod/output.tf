# VPC peering Connection ID
output "connection_id" {
  value       = module.peering-dev-prod.connection_id
  description = "VPC peering connection ID"
}

# Accept status for VPC peering
output "accept_status" {
  value       = module.peering-dev-prod.accept_status
  description = "The status of the VPC peering connection request"
}