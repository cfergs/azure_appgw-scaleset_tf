output "workspace" {
  description = "id of analytics workspace where diagnostics data can be sent"
  value       = azurerm_log_analytics_workspace.AnalyticsWorkspace.id
}
