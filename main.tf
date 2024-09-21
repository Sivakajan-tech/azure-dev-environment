terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# resource <resource_type> <resource_name/alias>
resource "azurerm_resource_group" "az-res-grp" {
  name     = "az-res-grp" # This not need to be same as alias.
  location = "East US"
  tags = {
    environment = "dev"
  }
}

# A Virtual Network and Reference to the Resource Group
resource "azurerm_virtual_network" "az-vn" {
  name = "az-virtual-network"

  # Below is creating a dependency on the resource group.
  # This means that the resource group will be created first and then the virtual network.
  # Also, we can not delete the resource group if the virtual network is present.
  resource_group_name = azurerm_resource_group.az-res-grp.name

  location = azurerm_resource_group.az-res-grp.location
  # The address space that is used by the virtual network.
  address_space = ["10.0.0.0/16"]
  tags = {
    environment = "dev"
  }
}

# A Subnet and Reference to the Virtual Network
resource "azurerm_subnet" "az-subnet" {
  name                 = "az-subnet" # "az-subnet-1"
  resource_group_name  = azurerm_resource_group.az-res-grp.name
  virtual_network_name = azurerm_virtual_network.az-vn.name
  address_prefixes     = ["10.0.0.0/24"] # This is the address space for the subnet.
}

# A Network Security Group and Reference to the Resource Group
resource "azurerm_network_security_group" "az-nsg" {
  name                = "az-nw-security-group"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name
  tags = {
    environment = "dev"
  }
  # security_rule = # This can be added here. But we are adding it separately.-> nsg_rule
}

# Network Security Rule and Reference to the Network Security Group
resource "azurerm_network_security_rule" "az-nsg-rule" {
  name                        = "az-network-security-group-rule"
  priority                    = 1001
  direction                   = "Inbound" # We are allowing access **to** our VM from outside.
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
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
  name                = "az-public-ip"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name
  allocation_method   = "Dynamic"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "az-nic" {
  name                = "az-network-interface"
  location            = azurerm_resource_group.az-res-grp.location
  resource_group_name = azurerm_resource_group.az-res-grp.name

  ip_configuration {
    name                          = "az-ip-configuration"
    subnet_id                     = azurerm_subnet.az-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az-pip.id
  }

  tags = {
    environment = "dev"
  }
}
