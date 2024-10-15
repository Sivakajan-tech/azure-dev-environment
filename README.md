# Azure dev Environment

This repository contains the code for the Azure Dev Environment project. The project is a simple infrastructure as code (IaC) project that creates a virtual network and a resource group in Azure using Terraform.

This Terraform project provisions an Azure environment with the following resources:
- Resource Group
- Virtual Network (VNet) and Subnet
- Network Security Group (NSG) with a security rule
- Public IP address
- Network Interface (NIC)
- Linux Virtual Machine (VM)

## Prerequisites

- Terraform 0.14+ installed on your machine.
- Azure subscription credentials set up locally (e.g., using Azure CLI or environment variables).
- SSH key pair for authentication with the VM.

## Usage

### 1. Clone the repository
```bash
git clone https://github.com/Sivakajan-tech/azure-dev-environment.git
cd azure-dev-environment
```

### 2. Configure variables
Edit the `variables.tf` file or provide the following variables through a `.tfvars` file or command line:

- `location`: The Azure region (e.g., East US).
- `environment`: The deployment environment (e.g., dev, prod).
- `virtual_machine_size`: The size of the VM (e.g., Standard_B1s).

Add your Subscription ID on the main.tf file.

### 3. Initialize Terraform
Run the following command to initialize the Terraform configuration:
```bash
terraform init
```

### 4. Plan the deployment
Use the following command to see the execution plan before applying:
```bash
terraform plan
```

### 5. Apply the configuration
Apply the Terraform configuration to create the Azure resources:
```bash
terraform apply
```
You will be prompted to confirm the apply process by typing `yes`.

### 6. Output
After the deployment is complete, the public IP of the VM will be displayed:

```bash
Outputs:
public_ip_address_id = "<VM Name>: <Public IP>"
```

You can use this IP to SSH into the virtual machine:


```bash
ssh adminuser@<public_ip_address> -i ~/.ssh/az-key
```

Make sure you use the private key that corresponds to the public key added during VM creation.

### 7. Destroy the resources
To destroy the Azure resources created by Terraform, run:
```bash
terraform destroy
```
You will be prompted to confirm the destruction by typing `yes`.
