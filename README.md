# Terraform Commands Cheat Sheet

This repository contains commonly used Terraform commands for infrastructure provisioning and management.

## Terraform Initialization

| Command          | Purpose                                             |
| ---------------- | --------------------------------------------------- |
| `terraform init` | Initialize Terraform project and download providers |

## Code Validation & Formatting

| Command              | Purpose                                                |
| -------------------- | ------------------------------------------------------ |
| `terraform validate` | Validate Terraform configuration syntax                |
| `terraform fmt`      | Format Terraform code according to Terraform standards |

## Planning & Deployment

| Command                         | Purpose                                        |
| ------------------------------- | ---------------------------------------------- |
| `terraform plan`                | Preview infrastructure changes before applying |
| `terraform apply`               | Create or update infrastructure                |
| `terraform apply -auto-approve` | Apply changes without confirmation prompt      |

## Resource Deletion

| Command                           | Purpose                                            |
| --------------------------------- | -------------------------------------------------- |
| `terraform destroy`               | Delete all managed infrastructure                  |
| `terraform destroy -auto-approve` | Destroy infrastructure without confirmation prompt |

## State & Output Management

| Command                | Purpose                                              |
| ---------------------- | ---------------------------------------------------- |
| `terraform show`       | Display current state or plan details                |
| `terraform output`     | Show output values defined in the configuration      |
| `terraform state list` | List resources tracked in the state file             |
| `terraform refresh`    | Update state file with actual infrastructure details |

## Provider Information

| Command               | Purpose                                  |
| --------------------- | ---------------------------------------- |
| `terraform providers` | Show providers used by the configuration |
| `terraform version`   | Display installed Terraform version      |

## Workspace Management

| Command                          | Purpose                         |
| -------------------------------- | ------------------------------- |
| `terraform workspace list`       | List all available workspaces   |
| `terraform workspace new dev`    | Create a new workspace          |
| `terraform workspace select dev` | Switch to an existing workspace |

## Resource Replacement

| Command                                       | Purpose                                         |
| --------------------------------------------- | ----------------------------------------------- |
| `terraform taint <resource>`                  | Mark a resource for recreation (legacy command) |
| `terraform apply -replace="aws_instance.web"` | Force recreation of a specific resource         |

## Import Existing Resources

| Command                            | Purpose                                             |
| ---------------------------------- | --------------------------------------------------- |
| `terraform import <resource> <id>` | Import existing infrastructure into Terraform state |

## Typical Terraform Workflow

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Quick Deployment

```bash
terraform init
terraform apply -auto-approve
```

## Quick Cleanup

```bash
terraform destroy -auto-approve
```

## Passing variable

```bash
terraform aaply -var="key_name=mykey" -var="instance_type=t2.micro"
```

## terraform refresh

- Used to update Terraform state with the actual infrastructure state.
Example: Suppose someone manually changed an EC2 tag in AWS.
Before refresh:
```bash
terraform show #shows old values
```
After terraform refresh: Terraform queries AWS and updates the local state file. terraform refresh is now depricated in newer terraform versions so use
```bash
terraform apply -refresh-only
```

## terraform show

- Displays the current state in a human-readable format.
```bash
terraform show
```

## Inspect the State File and Extract the EC2 Instance ID

View the state file
```bash
terraform state list
```
Display details of the EC2 resource
```bash
terraform state show aws_instance.myec2
```
