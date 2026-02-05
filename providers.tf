provider "databricks" {
  host = azurerm_databricks_workspace.this.workspace_url
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {}


data "azurerm_client_config" "current" {}