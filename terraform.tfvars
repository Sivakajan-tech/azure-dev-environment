location             = "Central India"
environment          = "dev"
virtual_machine_size = "Standard_B1s"


# terraform.tfvars is the default file to store variable values
# The file is in the same directory as the main configuration file
# If we want to use a different file, we can specify it with the -var-file flag
# terraform apply -var-file="prod.tfvars"
# You can check this with `terraform console -var-file="prod.tfvars"` command.
# The terraform console command is used to provide an interactive command-line interface for Terraform.
