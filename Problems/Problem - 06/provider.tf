provider "aws" {
  region = var.aws

  default_tags {
    tags = {
        Environment = var.environment
        ManagedBy = "Terraform"
        Project = "MyProject"
    }
  }
}
