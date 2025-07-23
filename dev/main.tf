
module "hub_vnet" {
  source              = "../modules/network"  
  vnet_name           = "hub-vnet"
  address_space       = "10.0.0.0/16"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnets = {
    bastion = "10.0.0.0/24"
  }
  peerings = {
    spoke-to-hub = {
      virtual_network_name =  module.spoke_vnet.vnet_name 
      remote_virtual_network_id = module.spoke_vnet.vnet_id
      allow_forwarded_traffic   = true
      allow_gateway_transit     = false
      use_remote_gateways       = false
    }
  }
}

module "spoke_vnet" {
  source              = "../modules/network"
  vnet_name           = "spoke-vnet"
  address_space       = "10.1.0.0/16"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnets = {
    app = "10.1.1.0/24"
    db  = "10.1.2.0/24"
  }
  peerings = {
    hub-to-spoke = {
        virtual_network_name =  module.hub_vnet.vnet_name
      remote_virtual_network_id = module.hub_vnet.vnet_id
      allow_forwarded_traffic   = true
      allow_gateway_transit     = false
      use_remote_gateways       = false
    }
  }
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.hub_vnet.vnet_name
  remote_virtual_network_id = module.spoke_vnet.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = module.spoke_vnet.vnet_name
  remote_virtual_network_id = module.hub_vnet.vnet_id
  allow_forwarded_traffic   = true
  allow_virtual_network_access = true
}


#VM creation
resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.spoke_vnet.subnet_ids["db"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "db_vm" {
  name                = "db-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.db_nic.id
  ]

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

  tags = {
    environment = "dev"
    tier        = "database"
  }
}
