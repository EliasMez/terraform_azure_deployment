### PROVIDERS OUTPUTS

output "tenant_id" {
  value = data.azuread_client_config.current.tenant_id
}


### KEYVAULT OUTPUTS

output "keyvault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.mezinekeyvaultnhood.name
}

output "keyvault_id" {
  description = "ID complet du Key Vault"
  value       = azurerm_key_vault.mezinekeyvaultnhood.id
}

output "keyvault_uri" {
  description = "URI utilisé pour accéder aux secrets"
  value       = azurerm_key_vault.mezinekeyvaultnhood.vault_uri
}


### PURVIEW OUTPUTS

output "purview_name" {
  description = "The name of the data catalog"
  value       = azurerm_purview_account.purview.name
}

output "purview_id" {
  description = "The ID of the data catalog"
  value       = azurerm_purview_account.purview.id
}


### SQL DATABASE

output "sql_server_fqdn" {
  value = azurerm_mssql_server.mezinesqlservernhood.fully_qualified_domain_name
}

output "dbname" {
  description = "Le nom de la base de données SQL."
  value       = azurerm_mssql_database.mezinesqldatabase.name
}

output "servername" {
  description = "Le nom du serveur SQL Azure."
  value       = azurerm_mssql_server.mezinesqlservernhood.name
}

output "sql_admin_password_secret" {
  description = "Nom du secret Key Vault contenant le mot de passe admin SQL."
  value       = azurerm_key_vault_secret.sql_admin_password.name
  sensitive   = true
}