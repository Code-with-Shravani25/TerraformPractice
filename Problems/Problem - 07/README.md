# Terraform AWS RSA Key Pair Creation

## Overview

This Terraform project automatically:

1. Generates an RSA key pair using the TLS provider.
2. Saves the private key (`.pem`) file locally.
3. Uploads the public key to AWS as an EC2 Key Pair.
4. Allows EC2 instances to use the generated key pair for SSH authentication.

---

## Architecture

```text
Terraform
    │
    ├── Generate RSA Key Pair
    │       │
    │       ├── Private Key (.pem)
    │       └── Public Key
    │
    ├── Save Private Key Locally
    │
    └── Upload Public Key to AWS
                    │
                    ▼
              AWS Key Pair
                    │
                    ▼
              EC2 Instance
```

---

## Terraform Configuration

### AWS Provider

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Specifies the AWS provider and region where resources will be created.

---

### Generate RSA Key Pair

```hcl
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

Generates:

* RSA Private Key
* RSA Public Key

Recommended key sizes:

| Key Size | Security |
| -------- | -------- |
| 2048     | Good     |
| 4096     | Strong   |

---

### Save Private Key Locally

```hcl
resource "local_file" "private_key_pem" {
  content         = tls_private_key.rsa_key.private_key_pem
  filename        = "${path.module}/mykey.pem"
  file_permission = "0600"
}
```

Creates:

```text
mykey.pem
```

Permission:

```bash
chmod 600 mykey.pem
```

Meaning:

* Owner: Read/Write
* Group: No Access
* Others: No Access

---

### Create AWS Key Pair

```hcl
resource "aws_key_pair" "generated_key" {
  key_name   = "mykey"
  public_key = tls_private_key.rsa_key.public_key_openssh
}
```

Uploads the generated public key to AWS.

AWS stores:

```text
Public Key Only
```

AWS does NOT store:

```text
Private Key
```

---

## Dependency Flow

Terraform automatically manages dependencies:

```text
tls_private_key
        │
        ├──► local_file
        │
        └──► aws_key_pair
```

No explicit `depends_on` is required.

---

## Using the Key Pair with EC2

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  key_name = aws_key_pair.generated_key.key_name
}
```

When the instance launches:

* AWS injects the public key into the instance.
* The instance is ready for SSH authentication.

---

## SSH Authentication Flow

```text
Your Laptop
    │
    ├── Private Key (mykey.pem)
    │
    ▼
EC2 Instance
    │
    └── Public Key
```

Connect using:

```bash
ssh -i mykey.pem ec2-user@<public-ip>
```

Authentication process:

1. Laptop presents proof of private key ownership.
2. EC2 verifies it against the stored public key.
3. Access is granted.

---

## Does AWS Store the Private Key?

No.

```text
AWS:
  Public Key ✅

Your Machine:
  Private Key ✅
```

The private key never leaves your machine.

---

## Alternative EC2 Access Methods

### SSH

```bash
ssh -i mykey.pem ec2-user@<public-ip>
```

Requires:

* Public IP
* Security Group allowing port 22
* Private Key

---

### EC2 Instance Connect

AWS Console:

```text
EC2 → Instances → Connect → EC2 Instance Connect
```

Requirements:

* Supported AMI
* Port 22 open
* IAM permissions

Private Key Required?

```text
No
```

---

### Session Manager (Recommended)

AWS Console:

```text
EC2 → Instances → Connect → Session Manager
```

Requirements:

* SSM Agent
* IAM Role with AmazonSSMManagedInstanceCore

Benefits:

* No SSH keys
* No port 22
* Browser-based access

Private Key Required?

```text
No
```

---

## Interview Questions

### Q: What does AWS store in a Key Pair?

**Answer:**

AWS stores only the public key.

---

### Q: Why do we save the `.pem` file?

**Answer:**

The `.pem` file contains the private key required for SSH authentication.

---

### Q: Can you download the private key from AWS later?

**Answer:**

No. AWS never stores the private key.

---

### Q: What happens if the `.pem` file is lost?

**Answer:**

You cannot SSH using that key pair anymore. You must:

* Create a new key pair, or
* Use Session Manager, if configured.

---

## Key Takeaways

* Terraform can generate RSA key pairs automatically.
* AWS stores only the public key.
* Private key remains on the user's machine.
* SSH requires the private key.
* Session Manager and EC2 Instance Connect do not require the `.pem` file.
* Protect the private key and never commit it to Git repositories.
