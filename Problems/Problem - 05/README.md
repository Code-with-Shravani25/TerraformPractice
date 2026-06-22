# Map variable in Terraform
---
- A map is a collection of key-value pairs. Think of it like dictionary
```bash
  variable "buckets" {
  default = {
    logs    = "log-bucket"
    images  = "img-bucket"
    backups = "backup-bucket"
  }
}
```
- each.key → Map key
- each.value → Map value

## How for_each works with a Map
---
When you use:
for_each = var.buckets
Terraform iterates through each key-value pair.  

## Why use for_each instead of creating 3 separate resources?
---
Without for_each:
```bash
resource "aws_s3_bucket" "logs" {}
resource "aws_s3_bucket" "images" {}
resource "aws_s3_bucket" "backups" {}
```
With for_each:
```bash
resource "aws_s3_bucket" "bucket" {
  for_each = var.buckets
}
```
## Benefits:

- Less code
- Easier maintenance
- Easily scalable (add/remove buckets from the map)
- Avoids duplicate resource blocks

## Example 1: Create 3 S3 buckets dynamically.Add bucket-specific tags using the map key.
variable.tf 
```bash
variable "buckets" {
  type = map(string)

  default = {
    logs    = "log-bucket"
    images  = "img-bucket"
    backups = "backup-bucket"
  }
}
```
main.tf
```bash
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  for_each = var.buckets

  bucket = each.value

  tags = {
    Name     = each.value
    Category = each.key
  }
}
```
Bucket 1:
```bash
Bucket Name : log-bucket

Tags:
Name     = log-bucket
Category = logs
```
Bucket 2:
```bash
Bucket Name : img-bucket

Tags:
Name     = img-bucket
Category = images
```
Bucket 3:
```bash
Bucket Name : backup-bucket

Tags:
Name     = backup-bucket
Category = backups
```
---
## Example 2: Create Multiple EC2 Instances
variable.tf
```bash
variable "instances" {
  default = {
    web   = "t2.micro"
    app   = "t2.small"
    db    = "t2.medium"
  }
}
```
main.tf
```bash
resource "aws_instance" "server" {
  for_each = var.instances

  ami           = "ami-12345678"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```
