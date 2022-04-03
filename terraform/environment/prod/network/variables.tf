# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group_9",
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Final_Project"
  description = "Name prefix"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.300.0.0/16"
  type        = string
  description = "VPC to host production machines"
}

# # Provision public subnets in custom VPC
# variable "public_subnet_cidrs" {
#   default     = ["10.100.1.0/24", "10.100.2.0/24"]
#   type        = list(string)
#   description = "Public Subnet CIDRs"
# }

# Provision private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.300.1.0/24", "10.300.2.0/24", "10.300.3.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

