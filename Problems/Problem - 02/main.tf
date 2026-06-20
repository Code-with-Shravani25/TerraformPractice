# Create an EC2 instance using count: Create 3 EC2 instances in one subnet.
provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "myec2" {
  instance_type = var.instance_type
  key_name = Demo
  ami = var.ami
  subnet_id = var.subnet
  vpc_security_group_ids = ["sg-0014e2d211f0a4462"]
  count = 3
}

output "public_ip" {
  description = "Public IPs of all EC2 instances"
  value       = aws_instance.myec2[*].public_ip
}
