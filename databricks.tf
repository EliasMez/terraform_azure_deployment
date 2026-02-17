resource "azurerm_databricks_workspace" "this" {
  name                        = "mezinedatabricksworkspace"
  resource_group_name         = local.resource_group_name
  location                    = local.location
  sku                         = "standard"

  depends_on = [azurerm_resource_group.rg]

  tags = {
    ManagedBy   = local.managed_by
    CreatedBy   = local.created_by
  }

}


resource "databricks_secret_scope" "mezinescopenhood" {
  name        = "mezinescopenhood"
  initial_manage_principal = "users"

  keyvault_metadata {
    resource_id = local.keyvault_id
    dns_name    = local.keyvault_uri
  }
}


## permet de recup le service principal créé automatiquement par databricks lors de la creation du secretScope plus haut
## c'est a ce sp qu'on doit donner les droits ACL KeyVault
data "azuread_service_principal" "sp_databricks" {
  display_name = "AzureDatabricks"
}




resource "databricks_directory" "folder" {
  path       = "${local.folder_path}"
}

resource "databricks_cluster" "cluster" {
  cluster_name    = "mezineclusternhood"
  spark_version   = "13.3.x-scala2.12"
  node_type_id      = "Standard_D2ads_v6"
  num_workers       = 1
  data_security_mode = "SINGLE_USER"
  spark_conf = {
  "fs.azure.account.auth.type.${local.storage_account_name}.dfs.core.windows.net" = "OAuth"
  "fs.azure.account.oauth.provider.type.${local.storage_account_name}.dfs.core.windows.net" = "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider"
  "fs.azure.account.oauth2.client.id.${local.storage_account_name}.dfs.core.windows.net" = "${local.application_id}"
  "fs.azure.account.oauth2.client.secret.${local.storage_account_name}.dfs.core.windows.net" = "{{secrets/${databricks_secret_scope.mezinescopenhood.name}/${local.secret_key_name}}}"
  "fs.azure.account.oauth2.client.endpoint.${local.storage_account_name}.dfs.core.windows.net" = "https://login.microsoftonline.com/${local.tenant_id}/oauth2/token"
}

}





resource "databricks_notebook" "mount_adls" {
  path     = "${local.folder_path}/mount_adls"
  language = "PYTHON"

  content_base64 = base64encode(<<-EOT
service_credential = dbutils.secrets.get(scope="${databricks_secret_scope.mezinescopenhood.name}", key="${local.secret_key_name}")
application_id = "${local.application_id}"
directory_id = "${local.tenant_id}"
storage_acc_name = "${local.storage_account_name}"
container_names = ${jsonencode(local.container_names)}
configs = {
  "fs.azure.account.auth.type": "OAuth",
  "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
  "fs.azure.account.oauth2.client.id": application_id,
  "fs.azure.account.oauth2.client.secret": service_credential,
  "fs.azure.account.oauth2.client.endpoint": f"https://login.microsoftonline.com/{directory_id}/oauth2/token"
}

for container_name in container_names:
    mount_point = f"/mnt/{container_name}"
    if not any(mount.mountPoint == mount_point for mount in dbutils.fs.mounts()):
        dbutils.fs.mount(
            source = f"abfss://{container_name}@{storage_acc_name}.dfs.core.windows.net/",
            mount_point = mount_point,
            extra_configs = configs
        )

# Déjà initialisé dans le cluster
# spark.conf.set(f"fs.azure.account.auth.type.{storage_acc_name}.dfs.core.windows.net", "OAuth")
# spark.conf.set(f"fs.azure.account.oauth.provider.type.{storage_acc_name}.dfs.core.windows.net", "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider")
# spark.conf.set(f"fs.azure.account.oauth2.client.id.{storage_acc_name}.dfs.core.windows.net", application_id)
# spark.conf.set(f"fs.azure.account.oauth2.client.secret.{storage_acc_name}.dfs.core.windows.net", service_credential)
# spark.conf.set(f"fs.azure.account.oauth2.client.endpoint.{storage_acc_name}.dfs.core.windows.net", f"https://login.microsoftonline.com/{directory_id}/oauth2/token")

print(dbutils.fs.ls(f"/mnt/{container_names[0]}"))
print(dbutils.fs.ls(f"abfss://{container_names[0]}@{storage_acc_name}.dfs.core.windows.net/"))

EOT
  )
}



resource "databricks_notebook" "dbconnexion" {
  path     = "${local.folder_path}/dbconnexion"
  language = "PYTHON"
  content_base64 = base64encode(<<-EOT
jdbc_hostname = "${azurerm_mssql_server.mezinesqlservernhood.name}.database.windows.net"
jdbc_port = 1433
jdbc_database = "${azurerm_mssql_database.mezinesqldatabase.name}"
jdbc_url = f"jdbc:sqlserver://{jdbc_hostname}:{jdbc_port};database={jdbc_database}"
username = "${var.administrator_login}"
password = dbutils.secrets.get(scope="${databricks_secret_scope.mezinescopenhood.name}", key="sql-admin-password")
table = "clients"

df = spark.read \
    .format("jdbc") \
    .option("url", jdbc_url) \
    .option("user", username) \
    .option("password", password) \
    .option("dbtable", table) \
    .load()

  EOT
)
}
