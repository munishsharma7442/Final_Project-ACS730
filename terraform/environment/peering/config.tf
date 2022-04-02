# S3 Bucket for Terraform state
terraform {
  backend "s3" {
    bucket = "peering-acs730-Final-Project"      // Bucket where to SAVE Terraform State
    key    = "peering-network/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                     // Region where bucket is created
  }
}