###################################################################
#####                 DEFAULT VALUES MAPPING                  #####
###################################################################

## The locals block is used to define the default values for the module:
## - Each variable is optional with null as default value
## - If the variable is not set, a default value will be computed based on the application trigram and the environment
## - If the variable is set, this value will override the default and be used instead

###################################################################
#####                     RESOURCE GROUPS                     #####
###################################################################

# Init the main resource group
resource "azurerm_resource_group" "rg" {

  name     = var.resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_state_storage_account" {
  count    = var.storage_account_resource_group_name != "" ? 1 : 0
  name     = var.storage_account_resource_group_name
  location = var.storage_account_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_backup_storage_account" {
  count    = var.backup_storage_account_resource_group_name != "" ? 1 : 0
  name     = var.backup_storage_account_resource_group_name
  location = var.backup_storage_account_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_law" {
  count    = var.log_analytics_workspace_resource_group_name != "" ? 1 : 0
  name     = var.log_analytics_workspace_resource_group_name
  location = var.log_analytics_workspace_location

  tags = var.tags
}

resource "azurerm_resource_group" "rg_network" {
  count    = var.network_resource_group_name != "" ? 1 : 0
  name     = var.network_resource_group_name
  location = var.resource_group_location

  tags = var.tags
}

###################################################################
#####                          STATE                          #####
###################################################################
module "state" {
  source = "git@github.com:padok-team/terraform-azurerm-storage-account.git?ref=v0.1.0"

  resource_group = {
    name     = var.storage_account_resource_group_name != "" ? azurerm_resource_group.rg_state_storage_account[0].name : var.resource_group_name
    location = var.storage_account_location != "" ? var.storage_account_location : var.resource_group_location
  }
  location                 = var.storage_account_location != "" ? var.storage_account_location : var.resource_group_location
  name                     = var.storage_account_name != "" ? var.storage_account_name : "${var.resource_group_name}state"
  account_replication_type = var.storage_account_replication_type

  ## Activate several options to prevent accidental loss of backups.
  blob_properties_delete_retention_policy_days           = 90
  blob_properties_versioning_enabled                     = true
  blob_properties_change_feed_enabled                    = true
  blob_properties_container_delete_retention_policy_days = 90
  ## To allow interaction with storage account
  network_rules_default_action = var.private_network_access ? "Deny" : "Allow"

  tags = var.tags
  ## Required to make sure the resource groups are created before the StorageAccount module creates a data on the resource group.
  depends_on = [
    azurerm_resource_group.rg
  ]
}
resource "azurerm_storage_container" "tfstate_container" {
  name                  = "tfstate"
  storage_account_name  = module.state.this.name
  container_access_type = "private"
}
###################################################################
#####                         LOGGING                         #####
###################################################################
module "law" {
  ## The deployment of a log analytics workspace is optional (but enabled by default).
  count  = var.enable_law_logging ? 1 : 0
  source = "git@github.com:padok-team/terraform-azurerm-logger.git?ref=v0.1.3"

  resource_group_name     = var.log_analytics_workspace_resource_group_name != "" ? azurerm_resource_group.rg_law[0].name : var.resource_group_name
  resource_group_location = var.log_analytics_workspace_location != "" ? var.log_analytics_workspace_location : var.resource_group_location
  name                    = var.log_analytics_workspace_name != "" ? var.log_analytics_workspace_name : "${var.resource_group_name}-logging"

  retention_in_days = 30

  resources_to_logs = [
    module.network.vnet.id,
  ]
  resources_to_metrics = [
    module.state.this.id,
    module.backup[0].this.id,
    module.network.vnet.id,
  ]

  tags = var.tags

  ## Required to make sure the resource groups are created before the DatadogLogs module creates a data on the resource group.
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_log_analytics_data_export_rule" "data_export_rule" {
  ## Deploy an export rule only if a LAW is deployed, and if a backup storage account is also deployed.
  count = var.enable_law_logging && var.enable_backup_storage_account ? 1 : 0

  name                    = var.log_analytics_workspace_data_export_name
  resource_group_name     = var.log_analytics_workspace_resource_group_name != "" ? azurerm_resource_group.rg_law[0].name : var.resource_group_name
  workspace_resource_id   = module.law[0].azurerm_log_analytics_workspace_id
  destination_resource_id = module.backup[0].this.id
  table_names = [
    "Alert",
    "AppCenterError",
    "AppServiceAuditLogs",
    "AppServiceAntivirusScanAuditLogs",
    "AppServiceConsoleLogs",
    "AppServiceHTTPLogs",
    "AppServiceIPSecAuditLogs",
    "AppServicePlatformLogs",
    "AzureActivity",
    "AzureMetrics",
    "CommonSecurityLog",
    "ComputerGroup",
    "ContainerRegistryLoginEvents",
    "ContainerRegistryRepositoryEvents",
    "HealthStateChangeEvent",
    "Heartbeat",
    "InsightsMetrics",
    "LinuxAuditLog",
    "Operation",
    "ProtectionStatus",
    "SecureScoreControls",
    "SecureScores",
    "SecurityAlert",
    "SecurityBaseline",
    "SecurityBaselineSummary",
    "SecurityDetection",
    "SecurityEvent",
    "SecurityNestedRecommendation",
    "SecurityRecommendation",
    "SecurityRegulatoryCompliance",
    "SqlAtpStatus",
    "SqlVulnerabilityAssessmentResult",
    "SqlVulnerabilityAssessmentScanStatus",
    "SysmonEvent",
    "Update",
    "UpdateSummary",
    "Usage",
    "VMBoundPort",
    "VMComputer",
    "VMConnection",
    "VMProcess",
    "WindowsFirewall"
  ]
  enabled = true
}

###################################################################
#####                         BACKUP                          #####
###################################################################

## The module supports the creation of a storage account for backup purposes.
## The settings for this storage account is :
##
## - soft_delete 90 days
## - blob delete retention 90 days
## - container delete retention 90 days
## - versioning enabled
## - change feed enabled


module "backup" {

  ## The deployment of a backup storage account is optional (but enabled by default).
  count  = var.enable_backup_storage_account ? 1 : 0
  source = "git@github.com:padok-team/terraform-azurerm-storage-account.git?ref=v0.1.0"

  resource_group = {
    name     = var.backup_storage_account_resource_group_name != "" ? azurerm_resource_group.rg_backup_storage_account[0].name : var.resource_group_name
    location = var.backup_storage_account_location != "" ? var.backup_storage_account_location : var.resource_group_location
  }
  location                 = var.backup_storage_account_location != "" ? var.backup_storage_account_location : var.resource_group_location
  name                     = var.backup_storage_account_name != "" ? var.backup_storage_account_name : "${var.resource_group_name}backup"
  account_replication_type = var.backup_storage_account_replication_type

  ## Activate several options to prevent accidental loss of backups.
  blob_properties_delete_retention_policy_days           = 90
  blob_properties_versioning_enabled                     = true
  blob_properties_change_feed_enabled                    = true
  blob_properties_container_delete_retention_policy_days = 90

  tags = var.tags

  ## Required to make sure the resource groups are created before the StorageAccount module creates a data on the resource group.
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

###################################################################
#####                          Network                        #####
###################################################################

module "network" {
  source = "git@github.com:padok-team/terraform-azurerm-network.git?ref=v0.1.0"

  vnet_name      = var.vnet_name
  resource_group = var.network_resource_group_name != "" ? azurerm_resource_group.rg_network[0] : azurerm_resource_group.rg

  vnet_address_space = var.vnet_address_space
  subnets            = var.subnets
  tags               = var.tags

  ## Required to make sure the resource groups are created before the VirtualNetwork module creates a data on the resource group.
  depends_on = [
    azurerm_resource_group.rg
  ]
}
