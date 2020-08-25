terraform {
  backend "azurerm" {
    storage_account_name = "mkservianterraformstate"
  }
}

provider "azurerm" {
  version = "=2.8.0"
  features {}

  client_id       = var.terraform_service_principal_client_id
  client_secret   = var.terraform_service_principal_client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

locals {
  applicationName = "servian-techtask"
  applicationNameTidy = replace(local.applicationName, "-", "")
}


resource "azurerm_resource_group" "default" {
  name     = local.applicationName
  location = var.location
}