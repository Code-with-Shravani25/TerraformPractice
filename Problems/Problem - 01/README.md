# Create EC2 instance

## Method 1:
```bash
# Create a simple EC2 instance

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo_ec2" {
  ami = "ami-091138d0f0d41ff90"
  instance_type = "t2.medium"
  key_name = "Demo"
  vpc_security_group_ids = ["sg-0014e2d211f0a4462"]
}

output "public_ip" {
  value = aws_instance.demo_ec2.public_ip
}
```
## Method 2:
main.tf
```bash
provider "aws" {
  region = "us-east-1"
}

# AMI ID Variable
variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

# Instance Type Variable
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Terraform-EC2"
  }
}

# Output Public IP
output "public_ip" {
  description = "Public IP of EC2 Instance"
  value       = aws_instance.web.public_ip
}
```
terraform.tfvars
```bash
ami_id        = "ami-0c55b159cbfafe1f0"
instance_type = "t2.micro"
```
