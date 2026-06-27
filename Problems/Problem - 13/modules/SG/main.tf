# We are not hardcoding the SG as usually we do, because the SG that we hardcode belongs to differnet vpc. So we create separate SG that lies under the vpc that we create
resource "aws_security_group" "ec2_sg" {
  name        = var.sg_name
  description = "Security Group for EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
