
module "hub_vnet" {
  source              = "../modules/network"  
  vnet_name           = "hub-vnet"
  address_space       = "10.0.0.0/16"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnets = {
    bastion = "10.0.0.0/24"
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
