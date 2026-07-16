# >>> archly:node:sql1 >>>
# Secrets manager entry for Azure SQL Primary
resource "azurerm_key_vault_secret" "sql1_password" {
  name         = "sql1-db-password"
  value        = var.sql1_administrator_password
  key_vault_id = azurerm_key_vault.kv1.id
}
# <<< archly:node:sql1 <<<

# >>> archly:node:sql2 >>>
# Secrets manager entry for Azure SQL Failover
resource "azurerm_key_vault_secret" "sql2_password" {
  name         = "sql2-db-password"
  value        = var.sql2_administrator_password
  key_vault_id = azurerm_key_vault.kv1.id
}
# <<< archly:node:sql2 <<<