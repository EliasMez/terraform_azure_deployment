# monitoring.tf

resource "azurerm_log_analytics_workspace" "law" {
  name                = local.analytics_name
  location            = local.location
  resource_group_name = local.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    ManagedBy = local.managed_by
    CreatedBy = local.created_by
  }
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_monitor_action_group" "email_alert" {
  name                = "Global-Email-Alert"
  resource_group_name = local.resource_group_name
  short_name          = "email-global"
  email_receiver {
    name          = "admin"
    email_address = "elias.mezine@laposte.net"
  }
  tags = {
    ManagedBy = local.managed_by
    CreatedBy = local.created_by
  }
  depends_on = [azurerm_resource_group.rg]
}