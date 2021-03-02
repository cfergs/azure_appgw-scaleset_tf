resource "azurerm_storage_account" "account" {
  name                      = var.name
  resource_group_name       = var.res_grp
  location                  = var.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  tags                      = var.tags
}

resource "azurerm_storage_container" "container" {
  count                   = length(var.containers)
  name                    = element(var.containers, count.index)
  storage_account_name    = azurerm_storage_account.account.name
  container_access_type   = var.container_access_type
}
