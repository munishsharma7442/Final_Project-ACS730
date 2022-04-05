# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Group_9"
    "App"   = "Web"
  }
}

# Prefix to identify resources
variable "prefix" {
  type    = string
  default = "ACS_Project"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

variable "ec2_count" {
  type    = number
  default = "2"
}

# Cloud9 Public IP
variable "my_public_ip" {
  type        = string
  description = "Public IP of my Cloud9"
  default     = "3.80.240.14"
}

# Cloud9 Private IP
variable "my_private_ip" {
  type        = string
  description = "Private IP of my Cloud9"
  default     = "172.31.41.107"
}