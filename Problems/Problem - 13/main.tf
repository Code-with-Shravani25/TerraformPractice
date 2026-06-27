# VPC Creation
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/VPC"
  vpc_cidr = "10.0.0.0/18"
  public_subnet_cidr ="10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  az = "us-east-1a"
}

module "security_group" {
  source = "./modules/SG"

  vpc_id  = module.vpc.vpc_id
  sg_name = "ec2-security-group"
}

module "ec2" {
  source = "./modules/EC2"
  ami_id = "ami-091138d0f0d41ff90"
  instance_type = "t2.medium"
  subnet_id = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
}
