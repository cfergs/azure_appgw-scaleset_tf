output "subnet" {
  description = "Output each of the subnets. just re-use them with their correct position in the array"
  value       = azurerm_subnet.subnet.*.id
}

output "subnet_prefix" {
  description = "Output the subnet address prefixes. just re-use them with their correct position in the array"
  value       = azurerm_subnet.subnet.*.address_prefix
}
