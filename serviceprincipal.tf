## Deploying the app registration
resource "azuread_application" "app_registration_mezine" {
  display_name = local.app_registration_datalake
  owners = [data.azuread_client_config.current.object_id]
  }

## Creating a secret (password)
resource "azuread_application_password" "app_registration_secret" {
  display_name = "Client Secret datalake"
  application_id = sensitive(azuread_application.app_registration_mezine.id)
  #end_date        = "2026-05-05T23:59:59Z"
  depends_on = [
    azuread_application.app_registration_mezine
  ]
  }


# Stockage du secret de l'app registration dans le keyvault
resource "azurerm_key_vault_secret" "app_secret" {
  name         = local.app_registration_datalake_secret
  value        = azuread_application_password.app_registration_secret.value
  key_vault_id = local.keyvault_id
}


## Service principal dans lequel on ajoute les droits d'accès au datalake
# resource "azuread_service_principal" "sp_datalake_acces" {
#   client_id = sensitive(azuread_application.app_registration_mezine.client_id)
# }
resource "azuread_service_principal" "sp_databricks" {
  client_id = sensitive(azuread_application.app_registration_mezine.client_id)
}






# ### App registration liée au principal de service ayant les droits d'accès au keyvault utilisé pour les services Azure interne
# ### (Databricks non concerné)

# ## Deploying the app registration
# resource "azuread_application" "app_registration_kv" {
#   display_name = "mezine_app_registration_kv_nhood"
#   owners = [data.azuread_client_config.current.object_id]
#   }

# ## Creating a secret (password)
# resource "azuread_application_password" "app_registration_secret_kv" {
#   display_name = "Client Secret KV"
#   application_id = sensitive(azuread_application.app_registration_kv.id)
#   #end_date        = "2025-05-05T23:59:59Z"
#   depends_on = [azuread_application.app_registration_kv]
#   }


# # Stockage du secret de l'app registration dans le keyvault
# resource "azurerm_key_vault_secret" "app_secret" {
#   name         = "mezine-app-registration-secret-nhood"
#   value        = azuread_application_password.app_registration_secret_kv.value
#   key_vault_id = var.keyvaultid
# }

# ## Service principal dans lequel on ajoute les droits d'accès au KeyVault
# resource "azuread_service_principal" "sp_kv_acces" {
#   client_id = sensitive(azuread_application.app_registration_mezine.client_id)
# }