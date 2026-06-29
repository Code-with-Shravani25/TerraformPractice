# Use depends_on correctly
# Scenario: Create a Security Group.Create an EC2 instance that should only initialize after SG is created.
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "mysg" {
  name = "Allow SSH"
  description = "Allow SSH"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami =  var.ami
  instance_type = var.instance_type
  key_name = "Demo"
  vpc_security_group_ids = [aws_security_group.mysg.id] # Due to this line terraform knows that sg needs to be created first then ec2
  depends_on = [ aws_security_group.mysg ] # Even if we dont mention it works the same way
}
