# Terraform `null_resource` with `local-exec`

## Overview

In Terraform, most resources create real infrastructure such as EC2 instances, VPCs, S3 buckets, or Security Groups.

However, `null_resource` is different.

A `null_resource` **does not create any infrastructure**. Instead, it is used to execute scripts or commands using provisioners such as:

* `local-exec`
* `remote-exec`

Think of it as a way to perform an action rather than create a cloud resource.

---

# Normal Terraform Resource

Consider the following example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"
}
```

When you run:

```bash
terraform apply
```

Terraform creates a real EC2 instance in AWS.

### Before `terraform apply`

```
AWS

(No EC2 Instance)
```

### After `terraform apply`

```
AWS

EC2 Instance
```

This is called **creating infrastructure** because a new AWS resource is created.

---

# `null_resource`

Now consider this example:

```hcl
resource "null_resource" "demo" {

  provisioner "local-exec" {
    command = "echo Hello"
  }

}
```

When you run:

```bash
terraform apply
```

Terraform **does not create any AWS resource**.

No EC2.

No VPC.

No S3 Bucket.

No Security Group.

Instead, it simply executes the command on the machine where Terraform is running.

Command executed:

```bash
echo Hello
```

Output:

```
Hello
```

Since no cloud infrastructure is created, it is called a **null resource**.

---

# Example: Save EC2 Public IP to a File

Suppose your Terraform configuration creates an EC2 instance.

```hcl
resource "aws_instance" "web" {
  ...
}
```

After the EC2 is created, you want to save its public IP address into a local file.

You can use a `null_resource`.

```hcl
resource "null_resource" "save_ip" {

  depends_on = [
    aws_instance.web
  ]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > ip.txt"
  }

}
```

---

# What Happens?

## Step 1

Terraform creates the EC2 instance.

```
AWS

EC2 Instance
```

---

## Step 2

Terraform executes the following command on your local machine:

```bash
echo 54.210.10.20 > ip.txt
```

A new file is created.

```
Your Computer

ip.txt
----------------
54.210.10.20
```

Notice that:

* The EC2 instance is created by `aws_instance`.
* The file is created by the shell command.
* The `null_resource` itself does not create any AWS infrastructure.

Its only purpose is to execute the command.

---

# Visual Representation

## Creating Infrastructure

```
Terraform
     │
     ▼
Create EC2
Create VPC
Create S3 Bucket
Create Security Group
```

These resources create actual infrastructure inside AWS.

---

## Executing Commands

```
Terraform
     │
     ▼
Run Shell Script
Create Local File
Call External API
Execute Deployment Script
```

These actions are performed using `null_resource`.

---

# Why Use `null_resource`?

`null_resource` is useful when you need to perform tasks that are **outside Terraform's infrastructure management**, such as:

* Running shell scripts
* Creating local files
* Saving EC2 information to a file
* Calling external APIs
* Triggering deployment scripts
* Executing custom automation

---

# Key Difference

| Normal Resource         | `null_resource`                                   |
| ----------------------- | ------------------------------------------------- |
| Creates infrastructure  | Creates no infrastructure                         |
| Managed by AWS provider | Executes commands or scripts                      |
| Example: EC2, VPC, S3   | Example: Run a shell command, create a local file |

---

# Easy Way to Remember

**Creates Infrastructure**

```hcl
resource "aws_instance" "web"
resource "aws_vpc" "main"
resource "aws_s3_bucket" "bucket"
resource "aws_security_group" "sg"
```

These resources create actual AWS infrastructure.

---

**Performs Actions**

```hcl
resource "null_resource" "demo"
```

This resource creates nothing in AWS.

It simply executes commands using provisioners like `local-exec` or `remote-exec`.

---

# Interview Question

### Q. What is a `null_resource` in Terraform?

**Answer:**

A `null_resource` is a special Terraform resource that does not create any cloud infrastructure. Instead, it is used to execute scripts or commands using provisioners such as `local-exec` or `remote-exec`. It is commonly used for automation tasks like running shell scripts, creating local files, or triggering external processes after infrastructure has been created.

### null resouce can be used withlocal exec or remote exec
# `local-exec` Provisioner

## What is `local-exec`?

The `local-exec` provisioner executes a command **on the machine where Terraform is running**.

For example, if Terraform is running on:

* Your laptop
* A Jenkins server
* A GitHub Actions runner
* An EC2 instance where Terraform is installed

then the command is executed **on that machine**, **not** on the AWS EC2 instance created by Terraform.

---

## Syntax

```hcl
provisioner "local-exec" {
  command = "echo Hello"
}
```

---

## Example

```hcl
resource "null_resource" "example" {

  provisioner "local-exec" {
    command = "echo Terraform executed successfully"
  }

}
```

When you run:

```bash
terraform apply
```

Terraform executes:

```bash
echo Terraform executed successfully
```

on the machine where Terraform is running.

### Execution Flow

```text
Your Laptop / Jenkins / GitHub Actions / Terraform Server
                    │
                    ▼
           terraform apply
                    │
                    ▼
         local-exec executes
                    │
                    ▼
echo Terraform executed successfully
```

---

## Common Use Cases

* Create a local file
* Execute shell scripts
* Trigger deployment scripts
* Call external APIs
* Send notifications
* Execute automation tasks on the local machine

---

# `remote-exec` Provisioner

## What is `remote-exec`?

The `remote-exec` provisioner executes commands **inside the remote machine**, such as an EC2 instance.

Unlike `local-exec`, Terraform first connects to the remote machine using:

* **SSH** (Linux)
* **WinRM** (Windows)

After establishing the connection, it executes the specified commands on the remote server.

---

## Syntax

```hcl
provisioner "remote-exec" {

  inline = [
    "sudo yum update -y",
    "sudo yum install httpd -y",
    "sudo systemctl start httpd",
    "sudo systemctl enable httpd"
  ]

}
```

---

## Connection Block

Before Terraform can execute commands on a remote machine, it must know **how to connect** to it.

This is done using the `connection` block.

```hcl
connection {
  type        = "ssh"
  user        = "ec2-user"
  private_key = file("Demo-Key.pem")
  host        = self.public_ip
}
```

### Explanation

* `type = "ssh"` → Connect using SSH.
* `user = "ec2-user"` → Login user for Amazon Linux.
* `private_key` → SSH private key used for authentication.
* `host = self.public_ip` → Public IP address of the EC2 instance.

---

## Example

```hcl
resource "aws_instance" "web" {

  ami           = "ami-xxxx"
  instance_type = "t2.micro"
  key_name      = "Demo-Key"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("Demo-Key.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

}
```

When you run:

```bash
terraform apply
```

Terraform performs the following steps:

1. Creates the EC2 instance.
2. Connects to the EC2 instance using SSH.
3. Executes the commands inside the EC2 instance.

### Execution Flow

```text
terraform apply
        │
        ▼
Create EC2 Instance
        │
        ▼
Connect using SSH
        │
        ▼
Run Commands
        │
        ▼
yum update
Install Apache
Start Apache
Enable Apache
```

---

# `local-exec` vs `remote-exec`

| `local-exec`                                       | `remote-exec`                                |
| -------------------------------------------------- | -------------------------------------------- |
| Executes commands on the machine running Terraform | Executes commands on the remote server (EC2) |
| No SSH connection required                         | Requires SSH (Linux) or WinRM (Windows)      |
| Used for local automation                          | Used for configuring remote servers          |
| Example: Create a local file                       | Example: Install Apache on EC2               |

---

# Easy Way to Remember

### `local-exec`

**Runs commands where Terraform is running.**

```text
Your Laptop
      │
terraform apply
      │
      ▼
echo Hello
```

---

### `remote-exec`

**Runs commands inside the remote EC2 instance.**

```text
Your Laptop
      │
terraform apply
      │
      ▼
Create EC2
      │
SSH Connection
      │
      ▼
EC2 Instance
      │
      ▼
sudo yum install httpd
```

---

