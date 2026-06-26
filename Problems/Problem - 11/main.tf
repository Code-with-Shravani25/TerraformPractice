# IAM User

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "myuser" {
  name = "myuser"
}

resource "aws_iam_access_key" "myuser_key" {
  user = aws_iam_user.myuser.name
}

output "access_key_id" {
  value = aws_iam_access_key.myuser_key.id
}

output "secret_access_key" {
  value = aws_iam_access_key.myuser_key.secret
  sensitive = true # tells Terraform that this output contains confidential information and should not be displayed in plain text in the terminal after terraform apply.
}
