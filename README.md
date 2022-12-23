# Azure Landing Zone Terraform module

Terraform module which creates a **Landing zone** on **Azure**.

## User Stories for this module

- AASRE I want to create all necessary resources to start a project on Azure
- AASRE I want to create all necessary resources with best practices

## Usage

```hcl
module "core" {
  source = "git@github.com:padok-team/terraform-azurerm-landing-zone.git?ref=v0.3.0"

  ## Common
  private_network_access  = false
  resource_group_name     = "projectname"
  resource_group_location = "francecentral"
}
```

## Examples

- [Example of simple project](examples/example_of_simple_project/main.tf)
- [Example of complex project](examples/example_of_complex_project/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backup"></a> [backup](#module\_backup) | git@github.com:padok-team/terraform-azurerm-storage-account.git | v0.2.2 |
| <a name="module_law"></a> [law](#module\_law) | git@github.com:padok-team/terraform-azurerm-logger.git | v0.3.0 |
| <a name="module_network"></a> [network](#module\_network) | git@github.com:padok-team/terraform-azurerm-network.git | v0.3.1 |
| <a name="module_state"></a> [state](#module\_state) | git@github.com:padok-team/terraform-azurerm-storage-account.git | v0.2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | The name of the resource group where to deploy core resources. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where to deploy core resources. | `string` | n/a | yes |
| <a name="input_backup_storage_account_location"></a> [backup\_storage\_account\_location](#input\_backup\_storage\_account\_location) | Location of the storage account for the backup. | `string` | `""` | no |
| <a name="input_backup_storage_account_name"></a> [backup\_storage\_account\_name](#input\_backup\_storage\_account\_name) | The name for the storage account. | `string` | `""` | no |
| <a name="input_backup_storage_account_replication_type"></a> [backup\_storage\_account\_replication\_type](#input\_backup\_storage\_account\_replication\_type) | The replication type for the storage account. | `string` | `"GRS"` | no |
| <a name="input_backup_storage_account_resource_group_name"></a> [backup\_storage\_account\_resource\_group\_name](#input\_backup\_storage\_account\_resource\_group\_name) | Resource group where to create the storage account for the state. | `string` | `""` | no |
| <a name="input_enable_backup_storage_account"></a> [enable\_backup\_storage\_account](#input\_enable\_backup\_storage\_account) | Enable backup storage account. | `bool` | `true` | no |
| <a name="input_enable_law_logging"></a> [enable\_law\_logging](#input\_enable\_law\_logging) | Enable log analytics workspace logging. | `bool` | `true` | no |
| <a name="input_enable_network"></a> [enable\_network](#input\_enable\_network) | Enable Network module. | `bool` | `true` | no |
| <a name="input_enable_storage_account"></a> [enable\_storage\_account](#input\_enable\_storage\_account) | Enable state storage account. | `bool` | `true` | no |
| <a name="input_log_analytics_workspace_data_export_name"></a> [log\_analytics\_workspace\_data\_export\_name](#input\_log\_analytics\_workspace\_data\_export\_name) | Name of the log analytics workspace data export rule. | `string` | `"default-export-law"` | no |
| <a name="input_log_analytics_workspace_location"></a> [log\_analytics\_workspace\_location](#input\_log\_analytics\_workspace\_location) | Location of the resource group where to create the log analytics workspace. | `string` | `""` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the log analytics workspace. | `string` | `""` | no |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | Name of the resource group where to create the log analytics workspace. | `string` | `""` | no |
| <a name="input_network_resource_group_name"></a> [network\_resource\_group\_name](#input\_network\_resource\_group\_name) | Resource group where to create the virtual network. | `string` | `""` | no |
| <a name="input_private_network_access"></a> [private\_network\_access](#input\_private\_network\_access) | Should you be able to access the resources only from a private network? Warning, you will need to configure your firewall to allow access to the resources, specifically for the state storage account | `bool` | `true` | no |
| <a name="input_storage_account_location"></a> [storage\_account\_location](#input\_storage\_account\_location) | Location where to create the storage account for the state. | `string` | `""` | no |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | The name for the storage account. | `string` | `""` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The replication type for the storage account. | `string` | `"GRS"` | no |
| <a name="input_storage_account_resource_group_name"></a> [storage\_account\_resource\_group\_name](#input\_storage\_account\_resource\_group\_name) | Resource group where to create the storage account for the state. | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets that are used the virtual network. You can supply more than one subnet. | `map(string)` | `{}` | no |
| <a name="input_subnets_delegations"></a> [subnets\_delegations](#input\_subnets\_delegations) | A map of delegations configurations for each subnets keys. | <pre>map(object({<br>    name = string<br>    service_delegation = object({<br>      name    = string<br>      actions = list(string)<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_subnets_service_endpoints"></a> [subnets\_service\_endpoints](#input\_subnets\_service\_endpoints) | A map of service endpoint list for each subnet keys. | `map(list(string))` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to the resources. | `map(string)` | `null` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | The address space that is used the virtual network. You can supply more than one address space. | `list(string)` | <pre>[<br>  "10.0.0.0/8"<br>]</pre> | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network. | `string` | `"default-vnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_storage_account"></a> [backup\_storage\_account](#output\_backup\_storage\_account) | Storage account for backup |
| <a name="output_log_analytics_workspace"></a> [log\_analytics\_workspace](#output\_log\_analytics\_workspace) | Log analytics workspace |
| <a name="output_network_subnet"></a> [network\_subnet](#output\_network\_subnet) | Subnet |
| <a name="output_network_vnet"></a> [network\_vnet](#output\_network\_vnet) | Virtual network |
| <a name="output_resource_group"></a> [resource\_group](#output\_resource\_group) | Resource group created |
| <a name="output_resource_group_backup_storage_account"></a> [resource\_group\_backup\_storage\_account](#output\_resource\_group\_backup\_storage\_account) | Resource group created |
| <a name="output_resource_group_law"></a> [resource\_group\_law](#output\_resource\_group\_law) | Resource group created |
| <a name="output_resource_group_network"></a> [resource\_group\_network](#output\_resource\_group\_network) | Resource group created |
| <a name="output_resource_group_state_storage_account"></a> [resource\_group\_state\_storage\_account](#output\_resource\_group\_state\_storage\_account) | Resource group created |
| <a name="output_state_storage_account"></a> [state\_storage\_account](#output\_state\_storage\_account) | Storage account for terraform state |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
