# VPC Accepter
variable "vpc_accepter" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}

# VPC Requester
variable "vpc_requester" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# ************* Note *****************
# AWS owner ID (Change default to your AWS Owner ID)
variable "owner_id" {
  default     = "651394275733"
  type        = string
  description = "VPC Peering Owner ID"
}

# VPC Requester CIDR range
variable "vpc_cidr_requester" {
  default     = ["10.100.0.0/16"] // DEV env
  type        = list(string)
  description = "VPC Peering to dev"
}

# VPC Accepter CIDR range
variable "vpc_cidr_accepter" {
  default     = ["10.200.0.0/16"] // STAGING env
  type        = list(string)
  description = "VPC Peering to staging"
}

