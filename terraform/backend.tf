terraform {

  backend "azurerm" {

    resource_group_name  = "rg-emf-dev-001"

    storage_account_name = "stemfdev001"

    container_name = "tfstate"

    key = "terraform.tfstate"

  }

}