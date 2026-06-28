# Terraform Locals (`locals.tf`)

## What is `locals.tf`?

`locals.tf` is a Terraform file that contains **local values (locals)**.

Local values are used **only within the current Terraform module** to avoid repeating the same values or expressions multiple times.

> **Note:** `locals.tf` is just a naming convention. You can define `locals` in any `.tf` file, but storing them in `locals.tf` keeps the project organized.

---

# Why do we use `locals.tf`?

Suppose you are creating the following AWS resources:

- VPC
- Subnet
- EC2

All belong to the same application.

Application Name:

```text
ecommerce
```

Environment:

```text
dev
```

Without using locals, you would write:

```hcl
resource "aws_vpc" "main" {
  tags = {
    Name = "ecommerce-dev-vpc"
  }
}

resource "aws_subnet" "public" {
  tags = {
    Name = "ecommerce-dev-public-subnet"
  }
}

resource "aws_instance" "web" {
  tags = {
    Name = "ecommerce-dev-ec2"
  }
}
```

Notice that:

- `ecommerce` is repeated 3 times.
- `dev` is repeated 3 times.

Imagine having 100 resources—you would repeat the same values many times.

---

# Using `locals.tf`

Create a file named `locals.tf`.

```hcl
locals {
  app = "ecommerce"
  env = "dev"
}
```

Now use the local values.

```hcl
resource "aws_vpc" "main" {
  tags = {
    Name = "${local.app}-${local.env}-vpc"
  }
}

resource "aws_subnet" "public" {
  tags = {
    Name = "${local.app}-${local.env}-public-subnet"
  }
}

resource "aws_instance" "web" {
  tags = {
    Name = "${local.app}-${local.env}-ec2"
  }
}
```

### Here,

```text
local.app
```

means

```text
ecommerce
```

and

```text
local.env
```

means

```text
dev
```

---

# What if the environment changes?

Initially:

```hcl
locals {
  app = "ecommerce"
  env = "dev"
}
```

Later, you want to deploy to QA.

Simply change one line.

```hcl
locals {
  app = "ecommerce"
  env = "qa"
}
```

Terraform automatically generates:

```text
ecommerce-qa-vpc
ecommerce-qa-public-subnet
ecommerce-qa-ec2
```

Only one line was changed, but every resource name was updated.

This is the biggest advantage of using locals.

---

# Variables vs Locals

Many beginners get confused between variables and locals.

## Variables

Variables are **input values provided by the user**.

Example:

```hcl
variable "region" {}
```

User can choose:

```text
us-east-1
```

or

```text
ap-south-1
```

Since different users or environments may use different regions, this should be a variable.

---

## Locals

Locals are **internal values used by Terraform**.

Example:

```hcl
locals {
  app = "ecommerce"
}
```

The application name is fixed for the project.

You don't want users to change it every time, so it is stored as a local value.

---

# Project Structure

```text
terraform/
│
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
```

### variables.tf

Contains values that users can provide.

Example:

```hcl
variable "environment" {}
```

---

### locals.tf

Contains reusable values used internally.

Example:

```hcl
locals {
  app = "ecommerce"
  env = "dev"
}
```

---

### main.tf

Creates AWS resources using variables and locals.

Example:

```hcl
resource "aws_vpc" "main" {
  tags = {
    Name = "${local.app}-${local.env}-vpc"
  }
}
```

---

# Advantages of `locals.tf`

- Avoids repeating the same values.
- Makes Terraform code cleaner.
- Easier to maintain.
- Easy to update project names or environments.
- Provides consistent naming across resources.
- Improves code readability.

---

# Quick Revision

| Variables | Locals |
|-----------|--------|
| User provides the value | Terraform uses the value internally |
| Can be overridden | Cannot be overridden |
| Access using `var.name` | Access using `local.name` |
| Used for inputs | Used for reusable values |

---

# Interview Questions

### 1. What is `locals.tf`?

`locals.tf` is a Terraform file that stores reusable values used within a module. It helps reduce code duplication and improves maintainability.

---

### 2. Why do we use locals?

We use locals to avoid repeating the same values multiple times, making the code cleaner and easier to maintain.

---

### 3. Can locals be overridden?

No. Local values cannot be overridden by users. They are internal to the Terraform module.

---

### 4. How do you access a local value?

Using:

```hcl
local.<name>
```

Example:

```hcl
local.app
```

---

### 5. What is the difference between `locals` and `variables`?

- **Variables** are user inputs.
- **Locals** are internal reusable values defined within the module.
