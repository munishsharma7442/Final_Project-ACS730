
# Create S3 Bucket
resource "aws_s3_bucket" "envs3" {
  bucket = "tf-${var.env}s3-final-project-acs730"
  tags = {
    Name        = "My bucket"
    Environment = "var.env"
  }
}

# Create ACL for S3
resource "aws_s3_bucket_acl" "envs3acl" {
  bucket = aws_s3_bucket.envs3.id
  acl    = "private"
}

# Limit access to S3
resource "aws_s3_bucket_public_access_block" "envs3acl" {
  bucket = aws_s3_bucket.envs3.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# ---------------------------
# Create S3 Bucket
resource "aws_s3_bucket" "envs32" {
  bucket = "tf-${var.env2}s3-final-project-acs730"
  tags = {
    Name        = "My bucket"
    Environment = "var.env2"
  }
}

# Create ACL for S3
resource "aws_s3_bucket_acl" "envs3acl2" {
  bucket = aws_s3_bucket.envs32.id
  acl    = "private"
}

# Limit access to S3
resource "aws_s3_bucket_public_access_block" "envs3acl2" {
  bucket = aws_s3_bucket.envs32.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# ---------------------------
# Create S3 Bucket
resource "aws_s3_bucket" "envs33" {
  bucket = "tf-${var.env3}s3-final-project-acs730"
  tags = {
    Name        = "My bucket"
    Environment = "var.env3"
  }
}

# Create ACL for S3
resource "aws_s3_bucket_acl" "envs3acl3" {
  bucket = aws_s3_bucket.envs33.id
  acl    = "private"
}

# Limit access to S3
resource "aws_s3_bucket_public_access_block" "envs3acl3" {
  bucket = aws_s3_bucket.envs33.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}


# ---------------------------

# Create S3 Bucket
resource "aws_s3_bucket" "peers3" {
  bucket = "peering-acs730-final-project"
  tags = {
    Name        = "My bucket"
    Environment = "var.env"
  }
}

# Create ACL for S3
resource "aws_s3_bucket_acl" "peers3acl" {
  bucket = aws_s3_bucket.peers3.id
  acl    = "private"
}

# Limit access to S3
resource "aws_s3_bucket_public_access_block" "peers3acl" {
  bucket = aws_s3_bucket.peers3.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}
