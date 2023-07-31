terraform {
  required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
    }    
  }
   backend "azurerm" {
    resource_group_name  = "mk-space-game-rg"
    storage_account_name = "mksagentstorage"
    container_name       = "mkstestcontainer"
    key                  = "infrax.tfstate"
  }
}

provider "azurerm" {
  features {    
  }
  skip_provider_registration = true
}


# Create virtual network
resource "azurerm_virtual_network" "azuredevopsnetwork" {
  name                = "AzureDevOpsVnet"
  address_space       = ["10.100.0.0/16"]
  location            = var.location
  resource_group_name = "${var.resourcegroup}"  
}


# Create subnet
resource "azurerm_subnet" "azuredevopssubnet" {
  name                 = "AzureDevopsSubnet"
  resource_group_name  = "${var.resourcegroup}"
  virtual_network_name = "${azurerm_virtual_network.azuredevopsnetwork.name}"
  address_prefixes       = ["10.100.1.0/24"]
  
}

# Create public IPs
resource "azurerm_public_ip" "azuredevopspublicip" {
  name                = "AzureDevOpsPublicIP"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup}"
  allocation_method   = "Dynamic" 
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "azuredevopsnsg" {
  name                = "AzureDevOpsNetworkSecurityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.resourcegroup}"  
}

# Create network interface
resource "azurerm_network_interface" "azuredevopsnic" {
  name                      = "AzureDevOpsNIC"
  location                  = "${var.location}"
  resource_group_name       = "${var.resourcegroup}"  

  ip_configuration {
    name                          = "AzureDevOpsNicConfiguration"
    subnet_id                     = "${azurerm_subnet.azuredevopssubnet.id}"
    private_ip_address_allocation = "Dynamic"
    
  }  
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${var.resourcegroup}"
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "azuredevopsstorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = "${var.resourcegroup}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"  
}

# Create virtual machine
resource "azurerm_virtual_machine" "azuredevopsvm" {
  name                  = "AzureDevOps"
  location              = "${var.location}"
  resource_group_name   = "${var.resourcegroup}"
  network_interface_ids = ["${azurerm_network_interface.azuredevopsnic.id}"]
  vm_size               = "${var.size}"

  storage_os_disk {
    name              = "AzureDevOpsOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "AzureDevOps"
    admin_username = "azuredevopsuser"
    admin_password ="Azureadmin123#"

  }

  os_profile_linux_config {
    disable_password_authentication = false    
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.azuredevopsstorageaccount.primary_blob_endpoint}"
  }

  
}

resource "azurerm_virtual_machine_extension" "azuredevopsvmex" {
  name                 = "hostname"    
  virtual_machine_id = "${azurerm_virtual_machine.azuredevopsvm.id}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
  "fileUris": ["https://gist.githubusercontent.com/MaxMelcher/bfe95eb55b33fa7b9bdbf68c9ac51811/raw/b42e685c6728e043d041e16c330c535a52bcf2ea/devops.sh"],
  "commandToExecute": "bash devops.sh '${var.url}' '${var.pat}' '${var.pool}' '${var.agent}'",
  "timestamp" : "11"
  }
SETTINGS

}