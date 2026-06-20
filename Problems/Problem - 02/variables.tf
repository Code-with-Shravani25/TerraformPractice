variable "ami" {
  description = "Ec2 ami id"
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet" {
  type = string
  default = "subnet-0275a717352c59f9b"
}
