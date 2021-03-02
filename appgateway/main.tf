resource "azurerm_public_ip" "pub_ip" {
  name                = "${var.name}-IP"
  location            = var.location
  resource_group_name = var.res_grp
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.name}-beap"
  frontend_port_name             = "${var.name}-feport"
  frontend_ip_configuration_name = "${var.name}-feip"
  http_setting_name              = "${var.name}-be-htst"
  listener_name                  = "${var.name}-httplstn"
  request_routing_rule_name      = "${var.name}-rqrt"
  redirect_configuration_name    = "${var.name}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.name}-appgw"
  resource_group_name = var.res_grp
  location            = var.location
  tags                = var.tags

  sku {
    name     = var.appgw_sku_name
    tier     = var.appgw_sku_tier
    capacity = var.appgw_sku_capacity
  }

  gateway_ip_configuration {
    name      = "${var.name}-ip-configuration"
    subnet_id = var.subnet
  }

  frontend_port {
    name  = local.frontend_port_name
    port  = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = var.appgw_cookie_affinity
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                        = local.request_routing_rule_name
    rule_type                   = "Basic"
    http_listener_name          = local.listener_name
    backend_address_pool_name   = local.backend_address_pool_name
    backend_http_settings_name  = local.http_setting_name
  }

  probe {
    name                  = "probe"
    interval              = 5
    protocol              = "http"
    path                  = "/"
    timeout               = 10
    unhealthy_threshold   = 2
    pick_host_name_from_backend_http_settings = true
  }
}

#monitoring
resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name                        = "${azurerm_application_gateway.network.name}-diagnostics"
  target_resource_id          = azurerm_application_gateway.network.id
  log_analytics_workspace_id  = var.diagnostics_workspace

  #if you do a foreach without wrapping within a dynamic block it will make 3 metric categories :/
  # also add the retention_policy logic otherwise TF will always detect changes
  
  dynamic "log" {
    for_each = toset(["AccessLog","PerformanceLog","FirewallLog"])
    content {
      category  = "ApplicationGateway${log.key}"
      enabled   = true

      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }
  
  metric {
    category  = "AllMetrics"
    enabled   = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
