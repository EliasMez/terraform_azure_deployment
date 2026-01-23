resource "azurerm_mssql_server" "mezinesqlservernhood" {
  name                         = local.sql_server_name
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password

  azuread_administrator {
    login_username = local.sql_aad_admin_login
    object_id      = local.object_id
    tenant_id      = local.tenant_id
  }

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_mssql_database" "mezinesqldatabase" {
  name       = local.sql_database_name
  server_id  = azurerm_mssql_server.mezinesqlservernhood.id
  sku_name   = "Basic"
}

# Commenté - User Managed Identity pas déployée
# resource "azurerm_role_assignment" "sqlserver_sql_db_contributor" {
#   scope                = azurerm_mssql_server.mezinesqlservernhood.id
#   role_definition_name = "SQL DB Contributor"
#   principal_id         = local.identity_principal_id
# }

# resource "azurerm_role_assignment" "sqldatabase_sql_db_contributor" {
#   scope                = azurerm_mssql_database.mezinesqldatabase.id
#   role_definition_name = "SQL DB Contributor"
#   principal_id         = local.identity_principal_id
# }

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.mezinesqlservernhood.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}


resource "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  value        = azurerm_mssql_server.mezinesqlservernhood.administrator_login_password
  key_vault_id = local.keyvault_id
}

resource "null_resource" "create_clients_table" {
  provisioner "local-exec" {
    command = <<EOT
      sqlcmd -S ${azurerm_mssql_server.mezinesqlservernhood.name}.database.windows.net \
      -d ${azurerm_mssql_database.mezinesqldatabase.name} \
      -U ${var.administrator_login} \
      -P ${var.administrator_login_password} \
      -Q "CREATE TABLE clients (id INT PRIMARY KEY, name NVARCHAR(100), email NVARCHAR(100))"
    EOT
  }
  depends_on = [azurerm_mssql_database.mezinesqldatabase]
}

resource "null_resource" "insert_clients_table" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 20 
      sqlcmd -S ${azurerm_mssql_server.mezinesqlservernhood.name}.database.windows.net \
      -d ${azurerm_mssql_database.mezinesqldatabase.name} \
      -U ${var.administrator_login} \
      -P ${var.administrator_login_password} \
      -Q "INSERT INTO clients (id, name, email) SELECT TOP 10 ABS(CHECKSUM(NEWID())) % 10000 + 1, CONCAT('Client_', LEFT(CAST(NEWID() AS NVARCHAR(50)), 5)), CONCAT('client_', LEFT(CAST(NEWID() AS NVARCHAR(50)), 8), '@test.com') FROM sys.objects;"
    EOT
  }
  depends_on = [azurerm_mssql_database.mezinesqldatabase]
}

