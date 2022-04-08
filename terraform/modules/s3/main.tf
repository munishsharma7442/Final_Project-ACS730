
# Create S3 Bucket
resource "aws_s3_bucket" "s3" {
  bucket = "tf-${var.env}s3-final-project-acs730"
  
  tags = {
    Name        = "My bucket"
    Environment = "var.env"
  }
}

# Create ACL for S3
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.s3.id
  acl    = "private"
}

# Limit access to S3
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}