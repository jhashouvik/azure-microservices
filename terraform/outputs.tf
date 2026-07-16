



















# >>> archly:node:azure_policy >>>
output "azure_policy_id" {
  description = "azurerm_policy id"
  value       = azurerm_policy.azure_policy.id
  sensitive   = false
}
# <<< archly:node:azure_policy <<<

# >>> archly:node:agw1 >>>
output "agw1_id" {
  description = "azurerm_application_gateway id"
  value       = azurerm_application_gateway.agw1.id
  sensitive   = false
}
# <<< archly:node:agw1 <<<

# >>> archly:node:blob1_pe >>>
output "blob1_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.blob1_pe.id
  sensitive   = false
}
# <<< archly:node:blob1_pe <<<

# >>> archly:node:defender >>>
output "defender_id" {
  description = "azurerm_security_hub id"
  value       = azurerm_security_hub.defender.id
  sensitive   = false
}
# <<< archly:node:defender <<<

# >>> archly:node:keyvault1 >>>
output "keyvault1_id" {
  description = "azurerm_manager id"
  value       = azurerm_manager.keyvault1.id
  sensitive   = false
}
# <<< archly:node:keyvault1 <<<

# >>> archly:node:keyvault1_pe >>>
output "keyvault1_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.keyvault1_pe.id
  sensitive   = false
}
# <<< archly:node:keyvault1_pe <<<

# >>> archly:node:managed_identity >>>
output "managed_identity_id" {
  description = "azurerm_managed id"
  value       = azurerm_managed.managed_identity.id
  sensitive   = false
}
# <<< archly:node:managed_identity <<<

# >>> archly:node:private_dns >>>
output "private_dns_id" {
  description = "azurerm_private id"
  value       = azurerm_private.private_dns.id
  sensitive   = false
}
# <<< archly:node:private_dns <<<

# >>> archly:node:rbac >>>
output "rbac_id" {
  description = "azurerm_identity_center id"
  value       = azurerm_identity_center.rbac.id
  sensitive   = false
}
# <<< archly:node:rbac <<<

# >>> archly:node:redis1_pe >>>
output "redis1_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.redis1_pe.id
  sensitive   = false
}
# <<< archly:node:redis1_pe <<<

# >>> archly:node:servicebus1_pe >>>
output "servicebus1_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.servicebus1_pe.id
  sensitive   = false
}
# <<< archly:node:servicebus1_pe <<<

# >>> archly:node:sql1_pe >>>
output "sql1_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.sql1_pe.id
  sensitive   = false
}
# <<< archly:node:sql1_pe <<<

# >>> archly:node:sql_failover_pe >>>
output "sql_failover_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.sql_failover_pe.id
  sensitive   = false
}
# <<< archly:node:sql_failover_pe <<<
