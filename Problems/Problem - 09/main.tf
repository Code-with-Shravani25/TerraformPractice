# Create EC2 using modules: modules of SG,keyfile and EC2

provider "aws" {
  region = "us-east-1"
}

module "keyfile" {
  source = "./modules/keyfile"
  key_name = "mykey1"
}

module "sg" {
  source = "./modules/SecurityGroup"
  vpc_id = "vpc-05e10e81b4fca8c96"
}

module "my_ec2" {
  source = "./modules/EC2"
  ami_id =  "ami-091138d0f0d41ff90" # the attributes used here are the variables name and not the actual attributes that needed.
  instance_type = "t2.medium"
  key_name = module.keyfile.key_name
  sg_id = module.sg.sg_id
}

# When one module needs to use a value created inside another module, that value must be exposed through an output.
# so keyfile module should expose key_name output and SG should expose sg_id in output
