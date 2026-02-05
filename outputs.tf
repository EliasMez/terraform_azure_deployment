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


### DATALAKE OUTPUTS
output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.datalake.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.datalake.id
}

output "container_names" {
  description = "The names of the storage containers"
  value       = [for container in azurerm_storage_container.container : container.name]
}

output "container_ids" {
  description = "The IDs of the storage containers"
  value       = [for container in azurerm_storage_container.container : container.id]
}


### IDENTITY OUTPUTS
output "identity_id" {
  value = azurerm_user_assigned_identity.user_identity.id
}

output "identity_name" {
  value = azurerm_user_assigned_identity.user_identity.name
}


### SERVICEPRINCIPAL OUTPUTS
output "datalakeCredentials" {
  sensitive = true
  value = {
    "clientID"     = azuread_application.app_registration_mezine.client_id
    "clientSecret" = azuread_application_password.app_registration_secret.value
    "datalakeClientObjectID" = azuread_service_principal.sp_databricks.object_id
  }
}

output "secret_key_name" {
  value = azurerm_key_vault_secret.app_secret.name
}



### DATAFACTORY OUTPUTS
output "data_factory_id" {
  description = "ID de la Data Factory"
  value       = azurerm_data_factory.adf.id
}

output "data_factory_name" {
  description = "Nom de la Data Factory"
  value       = azurerm_data_factory.adf.name
}

output "adf_managed_sys_principal_id" {
  description = "principal ID de l'identité managée par le système de datafactory"
  value       = azurerm_data_factory.adf.identity[0].principal_id
}



## DATABRICKS OUTPUTS
output "databricks_host" {
  value = azurerm_databricks_workspace.this.workspace_url
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.this.id
}

output "databricks_sp_oid" {
  description = "Object ID du service principal Azure Databricks"
  value       = data.azuread_service_principal.sp_databricks.object_id
}

output "databricks_sp_client_id" {
  description = "Object ID du service principal Azure Databricks"
  value       = data.azuread_service_principal.sp_databricks.client_id
}

output "spark_conf" {
  description = "Configuration datalake du cluster databricks"
  value       = databricks_cluster.cluster.spark_conf
  sensitive   = true
}