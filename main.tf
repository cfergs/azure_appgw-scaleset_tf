/*
Make sure to create a provider.tf file and populate with azure values. Otherwise you can't login!!
*/

resource "azurerm_resource_group" "res_grp" {
  name        = var.res_grp
  location    = var.location
  tags        = var.tags
}

module "network" {
  source                  = "./network"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
  address_space           = ["10.1.0.0/16"]
  subnets = [
    {
      subnet_name   = "App-GW"
      subnet_prefix = ["10.1.0.0/24"]
    },
    {
      subnet_name   = "Web"
      subnet_prefix = ["10.1.1.0/24"]
    }
  ]
}

module "nsg-appgw-internal" {
  depends_on              = [module.network]
  source                  = "./nsg"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
  name                    = "AppGW-NSG"
  rules = [
    {
      name                        = "webinbound_traffic"
      priority                    = "100"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_address_prefix       = "Internet"
      destination_port_range      = "80"
      destination_address_prefix  = module.network.subnet_prefix[0]
    },
    {
      name                        = "AllowAPPGWProbe"
      priority                    = "200"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_address_prefix       = "GatewayManager"
      destination_port_range      = "65200-65535"
    },
    {
      name                        = "AllowAzLB"
      priority                    = "300"
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_address_prefix       = "AzureLoadBalancer"
    }
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_appgw" {
  subnet_id                 = module.network.subnet[0]
  network_security_group_id = module.nsg-appgw-internal.id
}

resource "random_id" "name"	{
	byte_length = "4"
}

module "automation_storage" {
  source                  = "./storage"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
  name                    = "automation${random_id.name.dec}"
  containers              = ["scripts"]
}

module "log_analytics" {
  source                  = "./log_analytics"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
}

module "appgw" {
  source                  = "./appgateway"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
  name                    = "webappgw"
  subnet                  = module.network.subnet[0]
  diagnostics_workspace   = module.log_analytics.workspace
}

module "scaleset" {
  depends_on              = [module.automation_storage]
  source                  = "./scaleset"
  res_grp                 = azurerm_resource_group.res_grp.name
  location                = var.location
  tags                    = var.tags
  password                = var.vmpassword
  subnet                  = module.network.subnet[1]
  main_storage_acct       = module.automation_storage.account
  appgw_backend_pool      = module.appgw.backend_pool
}

output "PublicIP_ofApplicationGateway" {
  value = module.appgw.gateway_publicIPaddress
}
