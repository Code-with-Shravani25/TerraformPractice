# Terraform Workspaces

## Overview

Terraform Workspaces allow you to use the **same Terraform configuration** to manage multiple environments (such as **dev**, **qa**, and **prod**) while maintaining **separate state files** for each environment.

Instead of creating separate Terraform projects like:

```
terraform-dev/
terraform-qa/
terraform-prod/
```

You can maintain a **single codebase** and use workspaces to isolate the infrastructure state for each environment.

---

## Benefits of Workspaces

- Single Terraform codebase
- Separate state file for each environment
- Easy switching between environments
- Reduced code duplication
- Supports environment-specific configurations

---

## Creating Workspaces

Create a development workspace:

```bash
terraform workspace new dev
```

Create a QA workspace:

```bash
terraform workspace new qa
```

Create a production workspace:

```bash
terraform workspace new prod
```

---

## Listing Workspaces

To list all available workspaces:

```bash
terraform workspace list
```

Example Output:

```text
default
dev
qa
prod
```

The current workspace is marked with an asterisk (*).

Example:

```text
default
* dev
qa
prod
```

---

## Switching Workspaces

Switch to the **dev** workspace:

```bash
terraform workspace select dev
```

Switch to the **prod** workspace:

```bash
terraform workspace select prod
```

---

## Viewing the Current Workspace

To check the currently selected workspace:

```bash
terraform workspace show
```

Example Output:

```text
dev
```

---

## Using `terraform.workspace`

Terraform provides the built-in variable:

```hcl
terraform.workspace
```

It returns the name of the currently selected workspace.

Examples:

```
dev
```

or

```
qa
```

or

```
prod
```

---

# Example 1: Environment-Based EC2 Instance Type

```hcl
resource "aws_instance" "web" {

  ami = "ami-xxxxxxxx"

  instance_type = terraform.workspace == "prod" ? "t3.medium" : "t2.micro"

}
```

### Explanation

If the current workspace is:

| Workspace | Instance Type |
|-----------|---------------|
| dev | t2.micro |
| qa | t2.micro |
| prod | t3.medium |

This is useful because production environments usually require larger instance sizes than development or QA.

---

# Example 2: Environment-Based Resource Naming

```hcl
resource "aws_instance" "web" {

  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "web-${terraform.workspace}"
  }

}
```

Generated names:

| Workspace | Resource Name |
|-----------|---------------|
| dev | web-dev |
| qa | web-qa |
| prod | web-prod |

This makes it easy to identify resources created for different environments.

---

# Typical Workflow

### Step 1

Initialize Terraform

```bash
terraform init
```

---

### Step 2

Create workspaces

```bash
terraform workspace new dev
terraform workspace new qa
terraform workspace new prod
```

---

### Step 3

Select a workspace

```bash
terraform workspace select dev
```

---

### Step 4

Deploy infrastructure

```bash
terraform apply
```

Terraform creates resources using the **dev** workspace state.

---

### Step 5

Switch to production

```bash
terraform workspace select prod
```

---

### Step 6

Deploy again

```bash
terraform apply
```

Terraform now uses the **prod** workspace state and creates production resources.

---

# Common Workspace Commands

### Create a workspace

```bash
terraform workspace new <workspace-name>
```

Example:

```bash
terraform workspace new dev
```

---

### List workspaces

```bash
terraform workspace list
```

---

### Select a workspace

```bash
terraform workspace select <workspace-name>
```

Example:

```bash
terraform workspace select prod
```

---

### Show current workspace

```bash
terraform workspace show
```

---

### Delete a workspace

```bash
terraform workspace delete <workspace-name>
```

Example:

```bash
terraform workspace delete qa
```

> **Note:** You cannot delete the currently selected workspace. Switch to another workspace before deleting.

---

# Best Practices

- Use one workspace per environment (dev, qa, prod).
- Keep the same Terraform code for all environments.
- Use `terraform.workspace` for environment-specific settings.
- Store Terraform state remotely (e.g., Amazon S3 with DynamoDB state locking) when working in a team.
- Avoid hardcoding environment names in the configuration.

---

# Interview Questions

### 1. What is a Terraform Workspace?

A Terraform Workspace allows you to manage multiple environments using the same Terraform configuration while keeping separate state files for each environment.

---

### 2. Why use Terraform Workspaces?

- Separate infrastructure states
- Reusable Terraform code
- Easy environment management
- Less code duplication

---

### 3. What does `terraform.workspace` return?

It returns the name of the currently selected workspace.

Example:

```
dev
```

or

```
prod
```

---

### 4. How do you deploy different instance types for different environments?

Example:

```hcl
instance_type = terraform.workspace == "prod" ? "t3.medium" : "t2.micro"
```

---

### 5. How do you check the active workspace?

```bash
terraform workspace show
```

---

### 6. How do you switch between environments?

```bash
terraform workspace select dev
```

or

```bash
terraform workspace select prod
```

---

### 7. Can multiple workspaces share the same Terraform code?

Yes. All workspaces use the same Terraform configuration but maintain separate state files, allowing each environment to manage its own infrastructure independently.
