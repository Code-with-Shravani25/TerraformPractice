provider "aws" {
  region = var.aws # you can change the default value using terraform.tfvars

  default_tags {
    tags = {
        Environment = var.environment
        ManagedBy = "Terraform"
        Project = "MyProject"
    }
  }
}
