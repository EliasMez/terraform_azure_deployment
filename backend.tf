terraform {
  backend "azurerm" {
    subscription_id      = "d6798f99-944e-403b-b368-09fc240be7a3"
    resource_group_name  = "mezinenhood"
    storage_account_name = "mezinestorageaccnhood2"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
