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


# Lifecycle Management Policy - suppression automatique des blobs par couche
resource "azurerm_storage_management_policy" "lifecycle" {
  storage_account_id = azurerm_storage_account.datalake.id

  rule {
    name    = "delete-temp-after-7-days"
    enabled = true
    filters {
      prefix_match = ["00-temp/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 7
      }
    }
  }

  rule {
    name    = "delete-unprocessed-after-180-days"
    enabled = true
    filters {
      prefix_match = ["10-unprocessed/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 180
      }
    }
  }

  rule {
    name    = "delete-raw-after-730-days"
    enabled = true
    filters {
      prefix_match = ["20-raw/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 730
      }
    }
  }

  rule {
    name    = "delete-entity-after-3650-days"
    enabled = true
    filters {
      prefix_match = ["50-entity/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 3650
      }
    }
  }

  rule {
    name    = "delete-out-after-30-days"
    enabled = true
    filters {
      prefix_match = ["90-out/"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 30
      }
    }
  }
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



resource "azurerm_monitor_metric_alert" "storage_capacity" {
  name                = "Storage-Capacity-80"
  resource_group_name = local.resource_group_name
  scopes              = [azurerm_storage_account.datalake.id]
  description         = "Alerte si capacité stockage > 80%"

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }

  frequency   = "PT1H"
  window_size = "PT6H"
  severity    = 4

  tags = {
    ManagedBy = local.managed_by
    CreatedBy = local.created_by
  }

  depends_on = [azurerm_storage_account.datalake]
}