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

# These default tags will get automatically applied to all AWS resources created using that AWS provider, even if you don't specify a tags block in the resource
