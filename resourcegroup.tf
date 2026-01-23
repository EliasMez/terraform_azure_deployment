resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}


### reste : test apply, mettre droits acces kv keyvaultClientObjectId principal de service,
# ajouter ces credentials dans linked services,
# Synapse
# remplir bdd
# API