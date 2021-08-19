# Use Azure RM backend (needed for DevOps pipeline)
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
  required_version = ">= 0.12"
  backend "azurerm" {
    resource_group_name   = "Management"
    storage_account_name  = "terraformmgnt01"
    container_name        = "terraform"
    key                   = "terraform.tfstate"
  }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  subscription_id            = var.subscription_id
}