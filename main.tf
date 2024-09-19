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

resource "azurerm_resource_group" "az-res-grp" {
  name     = "az-res-grp" # This not need to be same as alias.
  location = "East US"
}
