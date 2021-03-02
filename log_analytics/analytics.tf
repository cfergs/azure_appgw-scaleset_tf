resource "azurerm_log_analytics_workspace" "AnalyticsWorkspace" {
  name                        = "${var.res_grp}Analytics"
  location                    = var.location
  resource_group_name         = var.res_grp
  sku                         = "PerGB2018"
  retention_in_days           = 30
  tags                        = var.tags
  internet_ingestion_enabled  = var.enable_internet_ingestion
  internet_query_enabled      = var.enable_internet_query
}

#stick solutions into index to simplify code
variable "solutions" {
  type    = list(string)
  default = ["AzureAppGatewayAnalytics"]
}

resource "azurerm_log_analytics_solution" "analytics" {
  count                 = length(var.solutions)
  solution_name         = var.solutions[count.index]
  location              = var.location
  resource_group_name   = var.res_grp
  workspace_resource_id = azurerm_log_analytics_workspace.AnalyticsWorkspace.id
  workspace_name        = azurerm_log_analytics_workspace.AnalyticsWorkspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/${var.solutions[count.index]}"
  }
}
