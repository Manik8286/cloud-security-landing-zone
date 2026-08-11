terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate"
  location = "centralindia"
  tags = {
    project = "secure-landing-zone"
    purpose = "terraform-state"
  }
}

resource "azurerm_storage_account" "tfstate" {
  name                            = "tfstateslz${random_id.suffix.hex}"
  resource_group_name             = azurerm_resource_group.tfstate.name
  location                        = azurerm_resource_group.tfstate.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = true  # backend auth needs this initially; can disable + switch to azuread auth after migration

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.my_public_ip]
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}