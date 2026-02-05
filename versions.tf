terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.66.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.8.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0"
    }
  }
}