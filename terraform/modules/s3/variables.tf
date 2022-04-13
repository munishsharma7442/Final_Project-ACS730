# Define variable for S3
variable "env" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

variable "env2" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

variable "env3" {
  default     = "staging"
  type        = string
  description = "Deployment Environment"
}
