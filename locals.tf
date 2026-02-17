data "azuread_client_config" "current" {}

locals {

### PROVIDERS
subscription_id          = data.azurerm_client_config.current.subscription_id
tenant_id                = data.azurerm_client_config.current.tenant_id
object_id                = data.azurerm_client_config.current.object_id

### RESOURCE GROUP
resource_group_name      = "mezinenhood"
location                 = "France Central"
otherlocation            = "North Europe"

### PUREVIEW
purview_name             = "mezinepurviewnhood"

### DATABASE
sql_server_name          = "mezineserveursqlnhood"
sql_database_name        = "mezinebasenhood"
sql_aad_admin_login      = "aadadmin"


### DATABRICKS
folder_path              = "/Shared/data_acces"
databricks_sp_oid        = data.azuread_service_principal.sp_databricks.object_id


# SERVICE PRINCIPAL
application_id           = azuread_application.app_registration_mezine.client_id
appRegistrationName      = "mezineserviceprincipalnhood"


### KEYVAULT
keyvault_name            = "mezinekeyvaultnhood"
secret_key_name          = azurerm_key_vault_secret.app_secret.name
keyvault_id              = azurerm_key_vault.mezinekeyvaultnhood.id
keyvault_uri             = azurerm_key_vault.mezinekeyvaultnhood.vault_uri

### DATALAKE
storage_account_name         = "mezinestorageaccnhood"
storage_account_id           = azurerm_storage_account.datalake.id
datalakeCredentials = {
    clientID              = azuread_application.app_registration_mezine.client_id
    clientSecret          = azuread_application_password.app_registration_secret.value
    datalakeClientObjectID = azuread_service_principal.sp_databricks.object_id
  }
container_names = [
    "00-temp",
    "10-unprocessed",
    "20-raw",
    "50-entity",
    "90-out"
  ]

container_tfstate                = "tfstate"
app_registration_datalake        = "mezine_app_registration_datalake_nhood"
app_registration_datalake_secret = "mezine-app-registration-secret-datalake-nhood"


### DATA FACTORY
factory_name                 = "mezinefactorynhood"
linked_service_datalake      = "mezine-ls-dtl"
linked_service_keyvault      = "ls-keyvault"
linked_service_sql_database  = "ls-azuresql"


### LOG ANALYTICS
analytics_name               = "mezine-law-nhood"

### TAGS
created_by                   = "Elias Mezine"
managed_by                   = "Terraform"
}




