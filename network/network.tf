resource "azurerm_virtual_network" "virtualNetwork" {
  name                = var.vnet_name
  address_space       = var.address_space
  resource_group_name = var.res_grp
  location            = var.location
  tags                = var.tags
}

resource "azurerm_subnet" "subnet"{
  count                 = length(var.subnets)
  name                  = var.subnets[count.index].subnet_name
  resource_group_name   = var.res_grp
  virtual_network_name  = azurerm_virtual_network.virtualNetwork.name
  address_prefixes      = var.subnets[count.index].subnet_prefix
}
