# Create RDS instance using Terraform
# Here we are creating storing secrets of RDS in AWS secrets manager

# First create secrets:
# Go to AWS console --> SecretsManager --> Create a new secret --> choose for other purpose
# Add in each row i.e in one row username = admin and in another row password = some password and give secrets name and save

#############################################
# Read Secret from AWS Secrets Manager
#############################################
# Here data means "read an existing AWS resource" and tells that under secretsmanager there is secret called rds-creds
data "aws_secretsmanager_secret" "db_secret" {
  name = "rds-creds"
}
# Now terraform knows the name of the secret, ARN and ID
# Example:
# Name: rds-creds
# ARN: arn:aws:secretsmanager:us-east-1:123456789012:secret:rds-creds
# ID: arn:aws:secretsmanager:us-east-1:123456789012:secret:rds-creds
# It still does not know the username or password.It only knows which secret you are referring to

# data.aws_secretsmanager_secret.db_secret.id this becomes something like arn:aws:secretsmanager:us-east-1:123456789012:secret:rds-creds
# This ID uniquely identifies the secret.
data "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
}

# Now Terraform says "I know which secret it is." Now give me its contents.

#############################################
# Decode Secret
#############################################

# AWS stores secrets as strings (secret.string)
# Terraform receives something like this : "{\"username\":\"admin\",\"password\":\"Password123!\"}"
# Before jsonencode Terraform has : "{\"username\":\"admin\",\"password\":\"Password123!\"}"
# jsondecode() converts JSON text into a Terraform object.
# After jsonencode: 
# Object
# username
# password
locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_secret_value.secret_string
  )
}

# Now Terraform understands
# db_credentials.username
# db_credentials.password

#############################################
# Create RDS MySQL Instance
#############################################

resource "aws_db_instance" "mysql" {

  identifier = "mysql-db"

  allocated_storage = 20
  storage_type      = "gp3"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  db_name = "mydb"

  username = local.db_credentials.username
  password = local.db_credentials.password

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

}
