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
purview_name             = "mezinepurviewnhood2"

### DATABASE
sql_server_name          = "mezineserveursqlnhood2"
sql_database_name        = "mezinebasenhood"
sql_aad_admin_login      = "aadadmin"

### KEYVAULT
keyvault_name            = "mezinekeyvaultnhood2"
keyvault_id              = azurerm_key_vault.mezinekeyvaultnhood.id
keyvault_uri             = azurerm_key_vault.mezinekeyvaultnhood.vault_uri

## MUI
identity_principal_id    = azurerm_user_assigned_identity.user_identity.principal_id
identity_id              = azurerm_user_assigned_identity.user_identity.id


### DATALAKE
storage_account_name         = "mezinestorageaccnhood2"
storage_account_id           = azurerm_storage_account.datalake.id

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

### TAGS
created_by                   = "Elias Mezine"
managed_by                   = "Terraform"
}




