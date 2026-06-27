provider "aws" {
  region = "us-east-1"
}

############################
# IAM Role
############################

resource "aws_iam_role" "ec2_role" {
  name = "EC2-S3-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = { # Principal specify who can assume the role
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole" # EC2 is allowed to obtain temporary credentials for this role
      }
    ]
  })
}

############################
# IAM Policy
############################

resource "aws_iam_policy" "s3_policy" {

  name = "EC2-S3-Access"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "*" # All S3 buckets and objects.
      }

    ]
  })
}

############################
# Attach Policy to Role
############################

resource "aws_iam_role_policy_attachment" "attach_policy" {

  role       = aws_iam_role.ec2_role.name ## instead of role we can attach it to user
  policy_arn = aws_iam_policy.s3_policy.arn
}

############################
# Instance Profile
############################
# An EC2 instance cannot attach an IAM Role directly.
# Instead, AWS requires an Instance Profile, which acts as a container for the IAM Role.
resource "aws_iam_instance_profile" "profile" {

  name = "EC2-S3-Profile"
  role = aws_iam_role.ec2_role.name
}

############################
# EC2 Instance
############################

resource "aws_instance" "myec2" {

  ami = "ami-091138d0f0d41ff90"
  instance_type = "t2.medium"
  key_name = "Demo"
  vpc_security_group_ids = ["sg-0014e2d211f0a4462"]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = {
    Name = "Terraform-EC2"
  }
}
