terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id = <subscription_id>
}

# resource <resource_type> <resource_name/alias>
resource "azurerm_resource_group" "az-res-grp" {
  name     = "az-res-grp-1" # This not need to be same as alias.
  location = var.location
  tags = {
    environment = var.environment
  }
}

# A Virtual Network and Reference to the Resource Group
resource "azurerm_virtual_network" "az-vn" {
  name = "az-virtual-network-1"

  # Below is creating a dependency on the resource group.
  # This means that the resource group will be created first and then the virtual network.
  # Also, we can not delete the resource group if the virtual network is present.
  resource_group_name = azurerm_resource_group.az-res-grp.name

  location = azurerm_resource_group.az-res-grp.location
  # The address space that is used by the virtual network.
  address_space = ["10.0.0.0/16"]
  tags = {
    environment = var.environment
  }
}

# A Subnet and Reference to the Virtual Network
resource "azurerm_subnet" "az-subnet" {
  name                 = "az-subnet-1" # "az-subnet-1"
  resource_group_name  = azurerm_resource_group.az-res-grp.name
  virtual_network_name = azurerm_virtual_network.az-vn.name
  address_prefixes     = ["10.0.0.0/24"] # This is the address space for the subnet.
}

# A Network Security Group and Reference to the Resource Group
resource "azurerm_network_security_group" "az-nsg" {
  name                = "az-nw-security-group-1"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name
  tags = {
    environment = var.environment
  }
  # security_rule = # This can be added here. But we are adding it separately.-> nsg_rule
}

# Network Security Rule and Reference to the Network Security Group
resource "azurerm_network_security_rule" "az-nsg-rule" {
  name                        = "az-network-security-group-rule-1"
  priority                    = 1001
  direction                   = "Inbound" # We are allowing access **to** our VM from outside.
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*" # This is the IP address range that the rule applies to.
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.az-res-grp.name
  network_security_group_name = azurerm_network_security_group.az-nsg.name
}

# Associate the Network Security Group with the Subnet
resource "azurerm_subnet_network_security_group_association" "az-nsg-association" {
  subnet_id                 = azurerm_subnet.az-subnet.id
  network_security_group_id = azurerm_network_security_group.az-nsg.id
}

# A Public IP and Reference to the Resource Group
resource "azurerm_public_ip" "az-pip" {
  name                = "az-public-ip-1"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags = {
    environment = var.environment
  }
}

# A Network Interface and Reference to the Resource Group and Subnet
resource "azurerm_network_interface" "az-nic" {
  name                = "az-network-interface-1"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name

  ip_configuration {
    name                          = "az-ip-configuration-1"
    subnet_id                     = azurerm_subnet.az-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az-pip.id
  }

  tags = {
    environment = var.environment
  }
}

# A Linux Virtual Machine and Reference to the Resource Group, Network Interface, and Image
# Manages a Linux Virtual Machine.
resource "azurerm_linux_virtual_machine" "az-vm" {
  name                = "az-linux-vm-1"
  resource_group_name = azurerm_resource_group.az-res-grp.name
  location            = azurerm_resource_group.az-res-grp.location
  size                = var.virtual_machine_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.az-nic.id
  ]

  # https://developer.hashicorp.com/terraform/language/functions/filebase64
  custom_data = filebase64("customdata.tpl")

  # To create a key pair, you can use the ssh-keygen command.
  /*
  PS C:\Users\sivak\Desktop\azure-dev-environment> ssh-keygen -t rsa
    Generating public/private rsa key pair.
    Enter file in which to save the key (C:\Users\sivak/.ssh/id_rsa): C:\Users\sivak/.ssh/az-key
    Your identification has been saved in C:\Users\sivak/.ssh/az-key.
    Your public key has been saved in C:\Users\sivak/.ssh/az-key.pub.
    The key fingerprint is:
    SHA256:gLCkc0hoE3OfCy10Wk8P0zNNq+n3TZnXC5+XL4a5rGg sivak@Sivakajan
    The key's randomart image is:
    +---[RSA 3072]----+
    |.++o o +. o.     |
    |o*+o*.+ ++ ..    |
    |= ++.+.. .o.     |
    | o  o ..  o      |
    |     .  So       |
    |        .       +|
    |         . . + ++|
    |        E...+ B.=|
    |       .. ..o+ *+|
    +----[SHA256]-----+
  PS C:\Users\sivak\Desktop\azure-dev-environment> ls C:\Users\sivak\.ssh\

        Directory: C:\Users\sivak\.ssh


    Mode                 LastWriteTime         Length Name
    ----                 -------------         ------ ----
    -a----        22/09/2024     00:54           2602 az-key
    -a----        22/09/2024     00:54            570 az-key.pub
    -a----        15/12/2023     12:09            174 known_hosts
  */
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/az-key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = var.environment
  }
}

data "azurerm_public_ip" "az-ip-data" {
  name                = azurerm_public_ip.az-pip.name
  resource_group_name = azurerm_resource_group.az-res-grp.name
}

output "public_ip_address_id" {
  value = "${azurerm_linux_virtual_machine.az-vm.name}: ${data.azurerm_public_ip.az-ip-data.ip_address}"
}
