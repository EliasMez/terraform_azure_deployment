resource "azurerm_data_factory" "adf" {
  name                = local.factory_name
  location            = local.location
  resource_group_name = local.resource_group_name
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [local.identity_id]
  }

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

  depends_on = [azurerm_resource_group.rg]
}

# Attribution des rôles de Azure Data Factory (ADF) pour l'identité managée par l'utilisateur
resource "azurerm_role_assignment" "adf_contributor" {
  scope                = azurerm_data_factory.adf.id
  role_definition_name = "Contributor"
  principal_id         = local.identity_principal_id
}

resource "azurerm_role_assignment" "adf_data_factory_contributor" {
  scope                = azurerm_data_factory.adf.id
  role_definition_name = "Data Factory Contributor"
  principal_id         = local.identity_principal_id
}


resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "datalake_ls" {
  name                  = local.linked_service_datalake
  data_factory_id       = azurerm_data_factory.adf.id
  use_managed_identity  = true
  url                   = "https://${local.storage_account_name}.dfs.core.windows.net"
}

# Rôle Storage Blob Data Contributor pour l'identité système ADF sur le Data Lake
resource "azurerm_role_assignment" "adf_datalake_blob_contributor" {
  scope                = local.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_data_factory.adf.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}


resource "azurerm_data_factory_linked_service_key_vault" "keyvault_linked_service" {
  name            = local.linked_service_keyvault
  data_factory_id = azurerm_data_factory.adf.id
  key_vault_id    = local.keyvault_id
  description     = "Key Vault linked service for storing secrets"
}


resource "azurerm_data_factory_linked_service_azure_sql_database" "sql_linked_service" {
  name            = local.linked_service_sql_database
  data_factory_id = azurerm_data_factory.adf.id
  connection_string = "Server=tcp:${azurerm_mssql_server.mezinesqlservernhood.name}.database.windows.net;Database=${azurerm_mssql_database.mezinesqldatabase.name};User ID=${var.administrator_login};"

  key_vault_password {
    linked_service_name = azurerm_data_factory_linked_service_key_vault.keyvault_linked_service.name
    secret_name         = "sql-admin-password"
  }
}