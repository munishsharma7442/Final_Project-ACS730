# VPC Accepter
variable "vpc_accepter" {
  default     = "prod"
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
  description = "VPC Peering to host static web site"
}

# VPC Requester CIDR range
variable "vpc_cidr_requester" {
  default     = ["10.100.0.0/16"] // DEV env
  type        = list(string)
  description = "VPC Peering to host static web site"
}

# VPC Accepter CIDR range
variable "vpc_cidr_accepter" {
  default     = ["10.30.0.0/16"] // Prod env
  type        = list(string)
  description = "VPC Peering to host static web site"
}
