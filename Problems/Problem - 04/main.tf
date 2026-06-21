# Create S3 with versioning enabled, block public access and add lifecycle rule to delete old versions after 30 days
# Bucket name should be : devops-bucket-<your_initials>-<random_number>

provider "aws" {
  region = "us-east-1"
}
# Random number for unique bucket name
resource "random_integer" "bucket_suffix" {
  min = 1000
  max = 9999
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "devops-bucket-sb-${random_integer.bucket_suffix.result}"
  # acl = private # only makes the bucket private by default
  # whereas Block Public Access actively prevents any public ACLs or bucket policies from exposing the bucket. 
  # Therefore, Block Public Access is the AWS-recommended way to secure S3 buckets
  # ACL = Access Control List
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Block All Public Access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration { # noncurrent means not the current versions, not the latest versions 
      noncurrent_days = 30
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.versioning # lifecycle needs versioning enabled
  ]
}

output "random_number" {
  value = random_integer.bucket_suffix.id
}
output "bucketname" {
  value = aws_s3_bucket.mybucket.bucket
}

# ACL private only sets the bucket ACL to private. 
# However, someone can still make the bucket public using a bucket policy. 
# Block Public Access is a stronger AWS security control that prevents public access through both ACLs and bucket policies, making it the recommended approach for securing S3 buckets.
