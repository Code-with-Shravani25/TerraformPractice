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
