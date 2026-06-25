# Userdata
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami = "ami-091138d0f0d41ff90"
  instance_type = "t2.medium"
  key_name = "Demo"
  vpc_security_group_ids = ["sg-0014e2d211f0a4462"]
  user_data = <<-EOF
  #!/bin/bash
  apt update -y
  apt install -y apache2
  systemctl start apache2
  systemctl enable apache2
  echo "Hello World" > /var/www/html/index.html
  EOF

  # or we can write the script in file and pass the file path
  # user_data = file("${path.module/script.sh") 
}
