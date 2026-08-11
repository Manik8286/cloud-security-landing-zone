terraform {
     required_version = ">= 1.5.0"
     required_providers {
       azurerm = {
         source  = "hashicorp/azurerm"
         version = "~> 3.100"   # pin two-segment form deliberately — you already know why
       }
     }
   }
   provider "azurerm" {
     features {}
   }