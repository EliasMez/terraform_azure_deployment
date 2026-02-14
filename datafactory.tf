resource "azurerm_data_factory" "adf" {
  name                = local.factory_name
  location            = local.location
  resource_group_name = local.resource_group_name
  identity {
    type = "SystemAssigned"
  }

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_monitor_diagnostic_setting" "adf_diag" {
  name                           = "adf-diagnostics-to-law"
  target_resource_id             = azurerm_data_factory.adf.id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
  log_analytics_destination_type = "Dedicated"  # ← FORCEMENT "Dedicated" pour tables ADFPipelineRun

  enabled_log {
    category = "PipelineRuns"
  }
  enabled_log {
    category = "ActivityRuns"
  }

  enabled_metric {
    category = "AllMetrics"
  }

  depends_on = [
    azurerm_data_factory.adf,
    azurerm_log_analytics_workspace.law
  ]
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "datalake_ls" {
  name                  = local.linked_service_datalake
  data_factory_id       = azurerm_data_factory.adf.id
  use_managed_identity  = true
  url                   = "https://${local.storage_account_name}.dfs.core.windows.net"
}

resource "azurerm_monitor_metric_alert" "adf_pipeline_failure" {
  name                = "ADF-Pipeline-Failure-Alert"
  resource_group_name = local.resource_group_name
  scopes              = [azurerm_data_factory.adf.id]
  description         = "Alerte déclenchée dès qu'une exécution de pipeline Data Factory échoue."

  criteria {
    metric_namespace = "Microsoft.DataFactory/factories"
    metric_name      = "ActivityFailedRuns"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 0
    skip_metric_validation = true
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }

  frequency   = "PT5M"
  window_size = "PT5M"
  severity    = 4

  tags = {
    ManagedBy = local.managed_by
    CreatedBy = local.created_by
  }

  depends_on = [
    azurerm_data_factory.adf
  ]
}

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