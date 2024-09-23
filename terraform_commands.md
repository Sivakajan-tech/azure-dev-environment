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
- This is same as `terraform apply -destroy`.

### State Management

- `terraform state list`: List resources in the Terraform state.
- `terraform state show <resource>`: Show detailed state information for a resource.

Eg:

```
PS C:\Users\sivak\Desktop\azure-dev-environment> terraform state list     
azurerm_resource_group.az-res-grp
azurerm_virtual_network.az-vn

PS C:\Users\sivak\Desktop\azure-dev-environment> terraform state show azurerm_resource_group.az-res-grp
# azurerm_resource_group.az-res-grp:
resource "azurerm_resource_group" "az-res-grp" {
    id       = "/subscriptions/7aed14a6-7fe2-4049-ad77-6c6481ffb640/resourceGroups/az-res-grp"
    location = "eastus"
    name     = "az-res-grp"
    tags     = {
        "environment" = "dev"
    }
}
```

- The `terraform show` command is used to provide the details about all state.

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
