terraform {
  required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
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
  features {    
  }
  skip_provider_registration = true
}

resource "azurerm_virtual_network" "mkvn" {
  name                = "mk-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.mkrg.location
  resource_group_name = "mk-space-game-rg"
}

