resource "azurerm_virtual_network" "gamer-cloud-001" {
  name                = "gamer-cloud-001"
  location            = var.location
  resource_group_name = "Management"
  address_space       = ["192.168.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]
}


resource "azurerm_subnet" "gamer-vms-snet" {  
  name                                           = "gamer-vms-snet"
  resource_group_name                            = "Management"
  virtual_network_name                           = azurerm_virtual_network.gamer-cloud-001.name
  address_prefixes                               = ["192.168.30.0/24"]
  #service_endpoints                              = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
}

resource "azurerm_public_ip" "gamer-vm01-p-ip" {
  name                = "gamer-vm01-p-ip"
  resource_group_name = azurerm_resource_group.gamer-vms.name
  location            = var.location
  allocation_method   = "Static"

}