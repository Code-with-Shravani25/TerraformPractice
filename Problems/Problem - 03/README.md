# Method 1
```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3bucket" {
  
}

output "bucketname" {
  value = aws_s3_bucket.s3bucket.bucket
}
```
# Method 2
```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = "hkgksf137"
}

output "bucketname" {
  value = aws_s3_bucket.s3bucket.bucket
}
```
