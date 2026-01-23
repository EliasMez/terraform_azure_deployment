# Création de l'identité managée par l'utilisateur
resource "azurerm_user_assigned_identity" "user_identity" {
  name                = "user-msi"
  resource_group_name = local.resource_group_name
  location            = local.location

  depends_on = [azurerm_resource_group.rg]
}