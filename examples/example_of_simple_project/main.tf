
terraform {
  required_version = ">= 0.13.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.82.0"
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

module "core" {
  source = "../../"

  ## Common
  private_network_access  = false
  resource_group_name     = random_pet.project_name.id
  resource_group_location = "francecentral"
}
