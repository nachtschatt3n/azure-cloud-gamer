resource "azurerm_network_interface" "gamer-vm01-nic" {
  name                = "gamer-vm01-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.gamer-vms.name

  ip_configuration {
    name                          = "gamer-vm01-config"
    subnet_id                     = azurerm_subnet.gamer-vms-snet.id
    private_ip_address_allocation = "Static"
    private_ip_address = "192.168.30.10"
    public_ip_address_id  = azurerm_public_ip.gamer-vm01-p-ip.id
  }
}

resource "azurerm_virtual_machine" "gamer-vm01" {
  name                  = "gamer-vm01"
  location              = var.location
  resource_group_name   = azurerm_resource_group.gamer-vms.name
  network_interface_ids = [azurerm_network_interface.gamer-vm01-nic.id]
  vm_size               = "Standard_NV4as_v4" 
  #zones = 1

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "20h1-pro-g2"
    version   = "latest"  
  }

  storage_os_disk {
    name              = "gamer-vm01-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    enable_automatic_upgrades = true
  }

  os_profile {
    computer_name  = "gamer-vms01"
    admin_username = "gadm"     # todo into keyvault
    admin_password = "g4mer0!_" # todo into keyvault
  }

#   additional_capabilities {
#     ultra_ssd_enabled = true
#   }

}


