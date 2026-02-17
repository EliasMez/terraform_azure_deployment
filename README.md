<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >= 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.8.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.66.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.7.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.60.0 |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.106.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.app_registration_mezine](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.app_registration_secret](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.sp_databricks](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_data_factory.adf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) | resource |
| [azurerm_data_factory_linked_service_azure_sql_database.sql_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_sql_database) | resource |
| [azurerm_data_factory_linked_service_data_lake_storage_gen2.datalake_ls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_data_lake_storage_gen2) | resource |
| [azurerm_data_factory_linked_service_key_vault.keyvault_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_key_vault) | resource |
| [azurerm_databricks_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/databricks_workspace) | resource |
| [azurerm_key_vault.mezinekeyvaultnhood](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.app_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.email_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.adf_diag](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.adf_pipeline_failure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.sql_dtu](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.storage_capacity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_mssql_database.mezinesqldatabase](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_firewall_rule.allow_azure_services](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.mezinesqlservernhood](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_purview_account.purview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/purview_account) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.adf_datalake_blob_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.datalake_storage_blob_data_contributor_sys](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.purview_sql_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.purview_subscription_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sp_databricks_storage_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.user_storage_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_storage_account.datalake](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.tfstate](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_management_policy.lifecycle](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy) | resource |
| [databricks_cluster.cluster](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster) | resource |
| [databricks_directory.folder](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/directory) | resource |
| [databricks_job.purge_clients_job](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/job) | resource |
| [databricks_notebook.dbconnexion](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_notebook.mount_adls](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_notebook.purge_clients_data](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/notebook) | resource |
| [databricks_secret_scope.mezinescopenhood](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope) | resource |
| [null_resource.create_clients_table](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.insert_clients_table](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_service_principal.sp_databricks](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_login"></a> [administrator\_login](#input\_administrator\_login) | Login de l'admin SQL Database. | `string` | n/a | yes |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | Mot de passe de l'admin SQL Database. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | id de la subscription | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_group_id"></a> [action\_group\_id](#output\_action\_group\_id) | ID de l'Action Group email |
| <a name="output_adf_managed_sys_principal_id"></a> [adf\_managed\_sys\_principal\_id](#output\_adf\_managed\_sys\_principal\_id) | principal ID de l'identité managée par le système de datafactory |
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | The IDs of the storage containers |
| <a name="output_container_names"></a> [container\_names](#output\_container\_names) | The names of the storage containers |
| <a name="output_data_factory_id"></a> [data\_factory\_id](#output\_data\_factory\_id) | ID de la Data Factory |
| <a name="output_data_factory_name"></a> [data\_factory\_name](#output\_data\_factory\_name) | Nom de la Data Factory |
| <a name="output_databricks_host"></a> [databricks\_host](#output\_databricks\_host) | # DATABRICKS OUTPUTS |
| <a name="output_databricks_sp_client_id"></a> [databricks\_sp\_client\_id](#output\_databricks\_sp\_client\_id) | Object ID du service principal Azure Databricks |
| <a name="output_databricks_sp_oid"></a> [databricks\_sp\_oid](#output\_databricks\_sp\_oid) | Object ID du service principal Azure Databricks |
| <a name="output_databricks_workspace_id"></a> [databricks\_workspace\_id](#output\_databricks\_workspace\_id) | n/a |
| <a name="output_datalakeCredentials"></a> [datalakeCredentials](#output\_datalakeCredentials) | ## SERVICEPRINCIPAL OUTPUTS |
| <a name="output_dbname"></a> [dbname](#output\_dbname) | Le nom de la base de données SQL. |
| <a name="output_keyvault_id"></a> [keyvault\_id](#output\_keyvault\_id) | ID complet du Key Vault |
| <a name="output_keyvault_name"></a> [keyvault\_name](#output\_keyvault\_name) | Nom du Key Vault |
| <a name="output_keyvault_uri"></a> [keyvault\_uri](#output\_keyvault\_uri) | URI utilisé pour accéder aux secrets |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | ID du workspace Log Analytics |
| <a name="output_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#output\_log\_analytics\_workspace\_name) | Nom du workspace Log Analytics |
| <a name="output_purview_id"></a> [purview\_id](#output\_purview\_id) | The ID of the data catalog |
| <a name="output_purview_name"></a> [purview\_name](#output\_purview\_name) | The name of the data catalog |
| <a name="output_purview_principal_id"></a> [purview\_principal\_id](#output\_purview\_principal\_id) | Principal ID de l'identité managée Purview |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Nom du resource group |
| <a name="output_secret_key_name"></a> [secret\_key\_name](#output\_secret\_key\_name) | n/a |
| <a name="output_servername"></a> [servername](#output\_servername) | Le nom du serveur SQL Azure. |
| <a name="output_sql_admin_password_secret"></a> [sql\_admin\_password\_secret](#output\_sql\_admin\_password\_secret) | Nom du secret Key Vault contenant le mot de passe admin SQL. |
| <a name="output_sql_connection_string"></a> [sql\_connection\_string](#output\_sql\_connection\_string) | Connection string SQL (sans password) |
| <a name="output_sql_server_fqdn"></a> [sql\_server\_fqdn](#output\_sql\_server\_fqdn) | n/a |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The ID of the storage account |
| <a name="output_storage_account_name"></a> [storage\_account\_name](#output\_storage\_account\_name) | The name of the storage account |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | ID de la subscription Azure |
| <a name="output_tenant_id"></a> [tenant\_id](#output\_tenant\_id) | n/a |
<!-- END_TF_DOCS -->