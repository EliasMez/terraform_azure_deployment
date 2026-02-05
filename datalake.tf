# Création du compte de stockage (Data Lake)
resource "azurerm_storage_account" "datalake" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }
  
  depends_on = [azurerm_resource_group.rg]
}

# Création du conteneur pour stocker le tfstate dans le Data Lake
resource "azurerm_storage_container" "tfstate" {
  name                  = local.container_tfstate
  storage_account_id    = azurerm_storage_account.datalake.id
  container_access_type = "private"
}

# Création des conteneurs dans le Data Lake
resource "azurerm_storage_container" "container" {
  for_each              = toset(local.container_names)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.datalake.id
  container_access_type = "private"
}


# Attribution des rôles à l'utilisateur Azure AD actuel pour le compte de stockage (optionnel)
# pour que ça fonctionne sur l'interface
resource "azurerm_role_assignment" "user_storage_access" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id

  lifecycle {
    ignore_changes = [role_definition_name, principal_id]
  }
}

# Attribution des rôles au principal de service possèdant les droits d'accès au datalake qui sera utilisé par databricks
resource "azurerm_role_assignment" "sp_databricks_storage_access" {
  scope                = azurerm_storage_account.datalake.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.datalakeCredentials.datalakeClientObjectID
}
