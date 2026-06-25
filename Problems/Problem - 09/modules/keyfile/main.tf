resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "private_key_pem" {
  content = tls_private_key.rsa_key.private_key_pem
  filename = "${path.module}/mykey.pem"
  file_permission = "0600"
}

resource "aws_key_pair" "generated_key" {
  key_name = var.key_name
  public_key = tls_private_key.rsa_key.public_key_openssh
}
