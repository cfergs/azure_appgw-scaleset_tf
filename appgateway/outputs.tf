output "backend_pool" {
  description = "backend pool ID that will be used to join the app gateway"
  value       = azurerm_application_gateway.network.backend_address_pool.0.id
}

output "gateway_publicIPaddress" {
  description = "Public IP used by the application gateway"
  value       = azurerm_public_ip.pub_ip.ip_address
}
