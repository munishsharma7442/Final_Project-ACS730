# Default tags
variable "default_tags" {
  default     = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}

# Instance type
variable "instance_type" {
  description = "Type of the instance"
  type        = map(string)
}

# Variable to signal the current environment 
variable "env" {
  type        = string
  description = "Deployment Environment"
}

# Variable for list of private subnet ids for vpc_zone_identifier
variable "vpc_zone_identifier" {
  description = "A list of subnets"
  type        = list(string)
  default     = null
}

# Variable for the security groups to attach to AWS Launch Configuration
variable "security_groups" {
  description = "Security group to attach to AWS Launch Configuration"
  type        = list(string)
  default     = []
}

# Variable for VPC_ID
variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = null
}

# Variable for LB Target Group ARN
variable "lb_target_group_arn" {
  description = "LB Target Group ARN"
  type        = string
  default     = null
}

# Variable for SSH Key 
variable "public_key" {
  description = "SSH Key"
  type        = string
  default     = null
}

variable "desired_size" {
  type        = number
  description = "Desired size for ASG"
}

