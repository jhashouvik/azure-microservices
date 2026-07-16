# >>> archly:node:appgw1 >>>
output "appgw1_id" {
  description = "azurerm_application_gateway id"
  value       = azurerm_application_gateway.appgw1.id
  sensitive   = false
}
# <<< archly:node:appgw1 <<<

# >>> archly:node:mi1 >>>
output "mi1_id" {
  description = "azurerm_managed id"
  value       = azurerm_managed.mi1.id
  sensitive   = false
}
# <<< archly:node:mi1 <<<

# >>> archly:node:sqlpe1 >>>
output "sqlpe1_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.sqlpe1.id
  sensitive   = false
}
# <<< archly:node:sqlpe1 <<<

# >>> archly:node:redispe1 >>>
output "redispe1_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.redispe1.id
  sensitive   = false
}
# <<< archly:node:redispe1 <<<

# >>> archly:node:sbpe1 >>>
output "sbpe1_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.sbpe1.id
  sensitive   = false
}
# <<< archly:node:sbpe1 <<<

# >>> archly:node:blobpe1 >>>
output "blobpe1_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.blobpe1.id
  sensitive   = false
}
# <<< archly:node:blobpe1 <<<

# >>> archly:node:kvpe1 >>>
output "kvpe1_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.kvpe1.id
  sensitive   = false
}
# <<< archly:node:kvpe1 <<<

# >>> archly:node:kv1 >>>
output "kv1_id" {
  description = "Key Vault id (reference this as key_vault_id elsewhere)"
  value       = azurerm_key_vault.kv1.id
  sensitive   = false
}
# <<< archly:node:kv1 <<<

# >>> archly:node:dns1 >>>
output "dns1_id" {
  description = "azurerm_private id"
  value       = azurerm_private.dns1.id
  sensitive   = false
}
# <<< archly:node:dns1 <<<

# >>> archly:node:logs1 >>>
output "logs1_id" {
  description = "azurerm_logging id"
  value       = azurerm_logging.logs1.id
  sensitive   = false
}
# <<< archly:node:logs1 <<<

# >>> archly:node:azure_policy >>>
output "azure_policy_id" {
  description = "azurerm_policy id"
  value       = azurerm_policy.azure_policy.id
  sensitive   = false
}
# <<< archly:node:azure_policy <<<

# >>> archly:node:microsoft_entra_id >>>
output "microsoft_entra_id_id" {
  description = "azurerm_identity_center id"
  value       = azurerm_identity_center.microsoft_entra_id.id
  sensitive   = false
}
# <<< archly:node:microsoft_entra_id <<<

# >>> archly:node:defender_for_cloud >>>
output "defender_for_cloud_id" {
  description = "azurerm_guardduty id"
  value       = azurerm_guardduty.defender_for_cloud.id
  sensitive   = false
}
# <<< archly:node:defender_for_cloud <<<

# >>> archly:node:sql2_pe >>>
output "sql2_pe_id" {
  description = "azurerm_private_endpoint id"
  value       = azurerm_private_endpoint.sql2_pe.id
  sensitive   = false
}
# <<< archly:node:sql2_pe <<<