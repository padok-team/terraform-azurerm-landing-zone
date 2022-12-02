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
