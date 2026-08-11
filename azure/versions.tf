terraform {
     required_version = ">= 1.5.0"
     required_providers {
       azurerm = {
         source  = "hashicorp/azurerm"
         version = "~> 3.100"   # pin two-segment form deliberately — you already know why
       }
     }
    backend "azurerm" {
    resource_group_name = "rg-tfstate"
    storage_account_name = "tfstateslzab49a348"
    container_name       = "tfstate"
    key                  = "secure-landing-zone.tfstate"
  }
}
provider "azurerm" {
     features {}
   }