# Terraform Workspaces Demo

## Objective

This project demonstrates how to use **Terraform Workspaces** to deploy infrastructure for multiple environments (**dev**, **qa**, and **prod**) using a **single Terraform codebase**.

Each workspace maintains its **own Terraform state**, allowing you to manage multiple environments independently.

---

# Project Structure

```text
terraform-workspace-demo/
│
├── provider.tf
├── variables.tf
├── main.tf
└── outputs.tf
```

---

# Step 1: Configure AWS Provider

Create **provider.tf**

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}
```

---

# Step 2: Create Variables

Create **variables.tf**

```hcl
variable "region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI"

  default = "ami-08a6efd148b1f7504"
}
```

> **Note:** Replace the AMI ID with a valid Amazon Linux AMI for your AWS Region.

---

# Step 3: Create EC2 Instance

Create **main.tf**

```hcl
resource "aws_instance" "web" {

  ami = var.ami_id

  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t2.micro"

  tags = {
    Name = "web-${terraform.workspace}"
  }

}
```

### Explanation

Terraform checks the currently selected workspace.

| Workspace | Instance Type | EC2 Name |
|-----------|--------------|----------|
| dev | t2.micro | web-dev |
| qa | t2.micro | web-qa |
| prod | t3.medium | web-prod |

---

# Step 4: Initialize Terraform

Initialize the working directory.

```bash
terraform init
```

Expected output:

```text
Terraform has been successfully initialized!
```

---

# Step 5: Create Workspaces

Create the **dev** workspace.

```bash
terraform workspace new dev
```

Output:

```text
Created and switched to workspace "dev".
```

Create the **qa** workspace.

```bash
terraform workspace new qa
```

Output:

```text
Created and switched to workspace "qa".
```

Create the **prod** workspace.

```bash
terraform workspace new prod
```

Output:

```text
Created and switched to workspace "prod".
```

---

# Step 6: List Available Workspaces

```bash
terraform workspace list
```

Example:

```text
default
dev
qa
* prod
```

The `*` indicates the currently active workspace.

---

# Step 7: Deploy Development Environment

Switch to the **dev** workspace.

```bash
terraform workspace select dev
```

Verify the active workspace.

```bash
terraform workspace show
```

Output:

```text
dev
```

Deploy the infrastructure.

```bash
terraform apply
```

Type:

```text
yes
```

Terraform creates:

| Resource | Value |
|----------|-------|
| EC2 Name | web-dev |
| Instance Type | t2.micro |

---

# Step 8: Verify in AWS

Open the AWS Management Console.

Navigate to:

```text
EC2 → Instances
```

You should see:

| Name | Instance Type |
|------|---------------|
| web-dev | t2.micro |

---

# Step 9: Deploy QA Environment

Switch to the **qa** workspace.

```bash
terraform workspace select qa
```

Verify:

```bash
terraform workspace show
```

Output:

```text
qa
```

Deploy:

```bash
terraform apply
```

Terraform creates another EC2 instance.

AWS Console:

| Name | Instance Type |
|------|---------------|
| web-dev | t2.micro |
| web-qa | t2.micro |

Since each workspace has its own state file, the `qa` deployment does not affect the `dev` deployment.

---

# Step 10: Deploy Production Environment

Switch to the **prod** workspace.

```bash
terraform workspace select prod
```

Verify:

```bash
terraform workspace show
```

Output:

```text
prod
```

Deploy:

```bash
terraform apply
```

Terraform creates:

| Resource | Value |
|----------|-------|
| EC2 Name | web-prod |
| Instance Type | t3.medium |

AWS Console now contains:

| Name | Instance Type |
|------|---------------|
| web-dev | t2.micro |
| web-qa | t2.micro |
| web-prod | t3.medium |

---

# Verify Using Terraform

## Check Current Workspace

```bash
terraform workspace show
```

Example:

```text
prod
```

---

## List All Workspaces

```bash
terraform workspace list
```

Example:

```text
default
dev
qa
* prod
```

---

## View Resources Managed by Current Workspace

```bash
terraform state list
```

Output:

```text
aws_instance.web
```

This command shows the resources tracked in the current workspace's state.

---

# Destroy Resources for Only One Workspace

Switch to the **dev** workspace.

```bash
terraform workspace select dev
```

Destroy the infrastructure.

```bash
terraform destroy
```

Type:

```text
yes
```

Only the **web-dev** EC2 instance is deleted.

The **web-qa** and **web-prod** instances remain because they are managed by different workspace state files.

---

# Verify in AWS

After destroying the **dev** workspace resources:

| Name | Status |
|------|--------|
| web-dev | Deleted |
| web-qa | Running |
| web-prod | Running |

---

# Common Workspace Commands

Create a workspace:

```bash
terraform workspace new <workspace-name>
```

Example:

```bash
terraform workspace new dev
```

---

List all workspaces:

```bash
terraform workspace list
```

---

Select a workspace:

```bash
terraform workspace select <workspace-name>
```

Example:

```bash
terraform workspace select prod
```

---

Show the active workspace:

```bash
terraform workspace show
```

---

Delete a workspace:

```bash
terraform workspace delete <workspace-name>
```

Example:

```bash
terraform workspace delete qa
```

> **Note:** You cannot delete the currently selected workspace. Switch to another workspace before deleting it.

---

# Key Takeaways

- Use **one Terraform codebase** for multiple environments.
- Each workspace maintains a **separate state file**.
- `terraform.workspace` returns the active workspace name.
- Use conditional expressions to customize infrastructure for different environments.
- Production resources can be configured differently from development and QA while keeping the same Terraform code.

---

# Interview Questions

### 1. What is a Terraform Workspace?

A Terraform Workspace allows you to manage multiple environments using the same Terraform configuration while keeping separate state files for each environment.

---

### 2. Why use Terraform Workspaces?

- Reuse the same Terraform code.
- Maintain separate state files.
- Easily manage dev, qa, and prod environments.
- Reduce code duplication.

---

### 3. What does `terraform.workspace` return?

It returns the name of the currently selected workspace.

Examples:

```text
dev
```

```text
qa
```

```text
prod
```

---

### 4. How do you deploy different EC2 instance types based on the environment?

```hcl
instance_type = terraform.workspace == "prod" ? "t3.medium" : "t2.micro"
```

---

### 5. How do you check the current workspace?

```bash
terraform workspace show
```

---

### 6. How do you switch between environments?

```bash
terraform workspace select dev
```

```bash
terraform workspace select qa
```

```bash
terraform workspace select prod
```

---

### 7. What happens when you run `terraform destroy` in a workspace?

Terraform destroys **only the resources managed by the currently selected workspace**. Resources in other workspaces remain unchanged because each workspace has its own state file.
