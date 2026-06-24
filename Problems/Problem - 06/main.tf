# Use a variable for region and default tags.Create variables: aws_region and environment
# Create default tags for all resources using: provider "aws" { default_tags {} }
resource "aws_instance" "demo_ec2" {
  ami = "ami-091138d0f0d41ff90"
  instance_type = "t2.medium"
  key_name = "Demo"
  vpc_security_group_ids = ["sg-0014e2d211f0a4462"]
}
