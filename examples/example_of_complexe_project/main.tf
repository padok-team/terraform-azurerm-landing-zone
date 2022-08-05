
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.92.0"
    }
  }
}
provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  features {}
}
resource "random_pet" "project_name" {
  length    = 2
  separator = ""
}
resource "random_pet" "resource_name" {
  length    = 2
  separator = ""
}

module "core" {
  source = "../../"

  ## Common
  private_network_access  = false
  resource_group_name     = random_pet.project_name.id
  resource_group_location = "francecentral"
  ## State
  storage_account_resource_group_name = "state"
  storage_account_location            = "westeurope"
  storage_account_name                = random_pet.resource_name.id
  ## LAW
  log_analytics_workspace_resource_group_name = "law"
  log_analytics_workspace_location            = "eastus"
  log_analytics_workspace_name                = random_pet.resource_name.id
  ## backup
  backup_storage_account_resource_group_name = "backup"
  backup_storage_account_location            = "canadacentral"
  backup_storage_account_replication_type    = "LRS"
  # Network
  network_resource_group_name = "network"
  vnet_name                   = random_pet.resource_name.id
  vnet_address_space = [
    "11.0.0.0/8",
  ]
  subnets = {
    "data"    = "11.0.0.0/28",
    "compute" = "11.0.0.16/28"
    "bastion" = "11.0.0.32/28"
  }
  ## Tags
  tags = {
    "library" = "true"
  }
}
