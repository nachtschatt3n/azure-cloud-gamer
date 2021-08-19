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
  priority            = "Spot"
  max_bid_price       = 0.6
  eviction_policy     = "Deallocate"
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_password.main.result
  allow_extension_operations = true
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}