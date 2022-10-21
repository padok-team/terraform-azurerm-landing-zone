###################################################################
#####                         COMMON                          #####
###################################################################

variable "private_network_access" {
  type        = bool
  description = "Should you be able to access the resources only from a private network? Warning, you will need to configure your firewall to allow access to the resources, specifically for the state storage account"
  default     = true
}
variable "tags" {
  description = "A map of tags to apply to the resources."
  type        = map(string)
  default     = null
}

variable "resource_group_name" {
  description = "The name of the resource group where to deploy core resources."
  type        = string
}
variable "resource_group_location" {
  description = "The name of the resource group where to deploy core resources."
  type        = string
}


###################################################################
#####                          STATE                          #####
###################################################################

variable "storage_account_resource_group_name" {
  description = "Resource group where to create the storage account for the state."
  type        = string
  default     = ""
}
variable "storage_account_location" {
  description = "Location where to create the storage account for the state."
  type        = string
  default     = ""
}
variable "storage_account_name" {
  description = "The name for the storage account."
  type        = string
  default     = ""
}

variable "storage_account_replication_type" {
  description = "The replication type for the storage account."
  type        = string
  default     = "GRS"
}

###################################################################
#####                      LOGGING - LAW                      #####
###################################################################

variable "enable_law_logging" {
  description = "Enable log analytics workspace logging."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_resource_group_name" {
  description = "Name of the resource group where to create the log analytics workspace."
  type        = string
  default     = ""
}
variable "log_analytics_workspace_location" {
  description = "Location of the resource group where to create the log analytics workspace."
  type        = string
  default     = ""
}
variable "log_analytics_workspace_name" {
  description = "Name of the log analytics workspace."
  type        = string
  default     = ""
}

variable "log_analytics_workspace_data_export_name" {
  description = "Name of the log analytics workspace data export rule."
  type        = string
  default     = "default-export-law"
}

###################################################################
#####                         BACKUP                          #####
###################################################################

variable "enable_backup_storage_account" {
  description = "Enable backup storage account."
  type        = bool
  default     = true
}

variable "backup_storage_account_resource_group_name" {
  description = "Resource group where to create the storage account for the state."
  type        = string
  default     = ""
}
variable "backup_storage_account_location" {
  description = "Location of the storage account for the backup."
  type        = string
  default     = ""
}

variable "backup_storage_account_name" {
  description = "The name for the storage account."
  type        = string
  default     = ""
}

variable "backup_storage_account_replication_type" {
  description = "The replication type for the storage account."
  type        = string
  default     = "GRS"
}

###################################################################
#####                          VNET                           #####
###################################################################

variable "network_resource_group_name" {
  description = "Resource group where to create the virtual network."
  type        = string
  default     = ""
}

variable "vnet_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "default-vnet"
}

variable "vnet_address_space" {
  description = "The address space that is used the virtual network. You can supply more than one address space."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "subnets" {
  description = "The subnets that are used the virtual network. You can supply more than one subnet."
  type        = map(string)
  default     = {}
}

variable "subnets_service_endpoints" {
  description = "A map of service endpoint list for each subnet keys."
  type        = map(list(string))
  default     = {}
}

variable "subnets_delegations" {
  description = "A map of delegations configurations for each subnets keys."
  type = map(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default = {}
}
