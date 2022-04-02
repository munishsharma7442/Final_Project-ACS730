# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}

# VPC CIDR range
variable "vpc_cidr" {
  type        = string
  description = "VPC to host static web site"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  type        = list(string)
  description = "Private Subnet CIDRs"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Variable to public - private
# variable "vpc_type" {
#   default = "private"
#   type= string
#   description="Private subnet"
# }

# Provision public subnets in custom VPC
# variable "private_cidr_blocks" {
#   default     = ["10.20.0.0/24", "10.20.1.0/24"]
#   type        = list(string)
#   description = "Public Subnet CIDRs"
# }