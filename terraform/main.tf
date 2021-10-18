# Use Azure RM backend (needed for DevOps pipeline)
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
  required_version = ">= 0.12"
  backend "azurerm" {
    resource_group_name   = "Management"
    storage_account_name  = "terraformmgnt01"
    container_name        = "terraform"
    key                   = "terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id            = var.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "main" {
  name                = "main-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "main" {
  name                = "main-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "main-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# resource "random_password" "main" {
#   length = 16
#   special = true
#   override_special = "_%@"
# }

resource "azurerm_windows_virtual_machine" "main" {
  name                = "gamer1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  priority            = "Spot"
  max_bid_price       = 0.75
  eviction_policy     = "Deallocate"
  size                = var.vm_size
  admin_username      = var.admin_username
  #admin_password      = random_password.main.result
  admin_password      = var.admin_password
  allow_extension_operations = true
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb = 
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
}

resource "azurerm_virtual_machine_extension" "gpudrivers" {
  name                 = "NvidiaGpuDrivers"
  virtual_machine_id   = azurerm_windows_virtual_machine.main.id
  publisher            = "Microsoft.HpcCompute"
  type                 = "NvidiaGpuDriverWindows"
  type_handler_version = "1.3"
  auto_upgrade_minor_version = true

}

resource "azurerm_virtual_machine_extension" "configureforansbile" {
  name                 = "ConfigureAnsible"
  virtual_machine_id   = azurerm_windows_virtual_machine.main.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  settings = <<SETTINGS
    {
        "commandToExecute": "powershell .\\ConfigureRemotingForAnsible.ps1",
        "fileUris" : ["https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"]
     }
  SETTINGS
}