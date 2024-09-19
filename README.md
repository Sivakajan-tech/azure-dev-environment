# Azure dev Environment

This repository contains the code for the Azure Dev Environment project. The project is a simple web application that allows users to create, read, update, and delete (CRUD) notes.

# Terraform Commands

A list of common Terraform commands used for managing infrastructure as code.

## Common Commands

### Initialization

- `terraform init`: Initialize a new or existing Terraform configuration.

### Validation

- `terraform validate`: Validate the Terraform configuration files.

### Formatting

- `terraform fmt`: Format the Terraform configuration files to a canonical format.

### Planning

- `terraform plan`: Generate and show an execution plan.

### Applying

- `terraform apply`: Build or change infrastructure according to the Terraform configuration.

### Destroying

- `terraform destroy`: Destroy the Terraform-managed infrastructure.

### State Management

- `terraform state list`: List resources in the Terraform state.
- `terraform state show <resource>`: Show detailed state information for a resource.

### Output

- `terraform output`: Show the outputs of the Terraform configuration.

### Providers

- `terraform providers`: Show the providers required for the configuration.

### Workspaces

- `terraform workspace list`: List all available workspaces.
- `terraform workspace select <workspace>`: Select a specific workspace.

### Importing

- `terraform import <address> <id>`: Import existing infrastructure into Terraform.

### Graphing

- `terraform graph`: Generate a visual representation of the configuration.

### Debugging

- `terraform debug`: Enable detailed logs for debugging purposes.

## Additional Resources

For more detailed information, refer to the [Terraform documentation](https://www.terraform.io/docs).
