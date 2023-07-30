terraform {
  required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }

    random = {
        source = "hashicorp/random"
         version = "3.5.1"
    }
    
  }
   backend "azurerm" {
    resource_group_name  = "mk-space-game-rg"
    storage_account_name = "mktseststorage"
    container_name       = "mkstestcontainer"
    key                  = "infrax.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

