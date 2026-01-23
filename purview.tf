resource "azurerm_purview_account" "purview" {
  name                = local.purview_name
  resource_group_name = local.resource_group_name
  location            = local.otherlocation

  identity {
    type = "SystemAssigned"
  }

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

  depends_on = [azurerm_resource_group.rg]
}

# Donne le rôle "Lecteur" à l'abonnement (ÉTAPE OBLIGATOIRE)
resource "azurerm_role_assignment" "purview_subscription_reader" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}

# Donne le rôle "Storage Blob Data Contributor" au stockage (désactivé - pas de Data Lake)
# resource "azurerm_role_assignment" "datalake_storage_blob_data_contributor_sys" {
#   scope                = local.storage_account_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_purview_account.purview.identity[0].principal_id
#   principal_type       = "ServicePrincipal"
#   depends_on = [azurerm_role_assignment.purview_subscription_reader]
# }

resource "azurerm_role_assignment" "purview_sql_reader" {
  scope                = azurerm_mssql_server.mezinesqlservernhood.id
  role_definition_name = "Reader"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  principal_type       = "ServicePrincipal"
  depends_on = [azurerm_role_assignment.purview_subscription_reader]
}



# # Création de la source de données SQL Server dans Purview
# resource "azapi_data_plane_resource" "purview_sql_datasource" {
#   type      = "Microsoft.Purview/accounts/Scanning/datasources@2023-09-01"
#   parent_id = "https://mezinepurviewnhood.purview.azure.com/scan" 
#   name      = "mezinesql-datasource" # Nom de la source dans Purview (peut être différent du serveur)

#   body = jsonencode({
#     "kind" = "AzureSqlDatabase"
#     "properties" = {
#       "server"   = azurerm_mssql_server.mezinesqlservernhood.name
#       "database" = azurerm_mssql_database.mezinesqldatabase.name
#       # L'authentification et la collection sont configurées ultérieurement via des scans ou le portail
#     }
#   })
# }
resource "azapi_resource" "purview_sql_datasource" {
  type                      = "Microsoft.Purview/accounts/datasources@2021-07-01"
  name                      = "mezinesql-datasource"
  parent_id                 = azurerm_purview_account.purview.id
  schema_validation_enabled = false

  body = jsonencode({
    kind = "AzureSqlDatabase"
    properties = {
      resourceGroup  = local.resource_group_name
      subscriptionId = local.subscription_id
      serverEndpoint = "${local.sql_server_name}.database.windows.net"
      resourceName   = local.sql_server_name
      resourceId     = azurerm_mssql_server.mezinesqlservernhood.id
      location       = local.location
    }
  })

  depends_on = [azurerm_purview_account.purview]
}