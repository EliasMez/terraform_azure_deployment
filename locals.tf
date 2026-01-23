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

### KEYVAULT
keyvault_name            = "mezinekeyvaultnhood"
keyvault_id              = azurerm_key_vault.mezinekeyvaultnhood.id
keyvault_uri             = azurerm_key_vault.mezinekeyvaultnhood.vault_uri

### TAGS
created_by                   = "Elias Mezine"
managed_by                   = "Terraform"
}




