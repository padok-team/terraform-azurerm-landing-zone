output "resource_group" {
  value       = azurerm_resource_group.rg
  description = "Resource group created"
}
output "resource_group_state_storage_account" {
  value       = azurerm_resource_group.rg_state_storage_account
  description = "Resource group created"
}
output "resource_group_backup_storage_account" {
  value       = azurerm_resource_group.rg_backup_storage_account
  description = "Resource group created"
}
output "resource_group_law" {
  value       = azurerm_resource_group.rg_law
  description = "Resource group created"
}
output "resource_group_network" {
  value       = azurerm_resource_group.rg_network
  description = "Resource group created"
}

###################################################################
#####                          STATE                          #####
###################################################################
output "state_storage_account" {
  value       = module.state.this
  description = "Storage account for terraform state"
}
output "backup_storage_account" {
  value       = module.backup[0].this
  description = "Storage account for backup"
}


###################################################################
#####                         LOGGING                         #####
###################################################################
output "log_analytics_workspace" {
  value       = module.law[0].azurerm_log_analytics_workspace_id
  description = "Log analytics workspace"
}

###################################################################
#####                          Network                        #####
###################################################################
output "network_vnet" {
  value       = module.network.vnet
  description = "Virtual network"
}
output "network_subnet" {
  value       = module.network.subnets
  description = "Subnet"
}
