resource "azurerm_key_vault" "mezinekeyvaultnhood" {
  name                        = local.keyvault_name
  location                    = local.location
  resource_group_name         = local.resource_group_name
  tenant_id                   = local.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true

  access_policy {
    tenant_id = local.tenant_id
    object_id = local.object_id
    secret_permissions = ["Get", "List", "Set", "Delete","Recover"]
  }

  access_policy {
    tenant_id = local.tenant_id
    object_id = azurerm_purview_account.purview.identity[0].principal_id
    secret_permissions = ["Get","List"]
  }

  access_policy {
    tenant_id = local.tenant_id
    object_id = azurerm_data_factory.adf.identity[0].principal_id
    secret_permissions = ["Get", "List"]
  }

  access_policy {
    tenant_id = local.tenant_id
    object_id = local.databricks_sp_oid
    secret_permissions = ["Get", "List"]
  }

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

  depends_on = [azurerm_resource_group.rg]
}