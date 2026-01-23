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

# Donne le rôle "Lecteur" à l'abonnement
resource "azurerm_role_assignment" "purview_subscription_reader" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  principal_type       = "ServicePrincipal"
}


resource "azurerm_role_assignment" "purview_sql_reader" {
  scope                = azurerm_mssql_server.mezinesqlservernhood.id
  role_definition_name = "Reader"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  principal_type       = "ServicePrincipal"
  depends_on = [azurerm_role_assignment.purview_subscription_reader]
}


resource "azurerm_role_assignment" "datalake_storage_blob_data_contributor_sys" {
  scope                = local.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  principal_type       = "ServicePrincipal"
  depends_on = [azurerm_role_assignment.purview_subscription_reader]
}