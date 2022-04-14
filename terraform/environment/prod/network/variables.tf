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
  default     = "Group9"
  description = "Name prefix"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.30.0.0/16"
  type        = string
  description = "VPC to host production machines"
}

# Provision public subnets in Prod VPC
variable "public_subnet_cidrs" {
  default     = ["10.30.1.0/24", "10.30.2.0/24", "10.30.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs for Prod"
}


# Provision private subnets in Prod VPC
variable "private_subnet_cidrs" {
  default     = ["10.30.4.0/24", "10.30.5.0/24", "10.30.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs for Prod"
}

# Variable to signal the current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}