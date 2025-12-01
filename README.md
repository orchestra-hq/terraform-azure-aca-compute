# terraform-azure-aca-compute

Deploy an Azure Container App Job (with relevant resources) for a hybrid compute option with Orchestra.

## Contributing

When making contributions, ensure that pre-commit is installed and enabled, (e.g. by running `pre-commit install`).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.54 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.7.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.54.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_container_app_job.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_job) | resource |
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_role_assignment.container_app_job](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [random_id.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_app_environment) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_compute_resources"></a> [compute\_resources](#input\_compute\_resources) | A map representing the compute resources (CPU and memory) to use for each integration. | <pre>map(object({<br/>    cpu    = number<br/>    memory = number<br/>  }))</pre> | <pre>{<br/>  "dbt_core": {<br/>    "cpu": "0.5",<br/>    "memory": "1Gi"<br/>  },<br/>  "python": {<br/>    "cpu": "0.5",<br/>    "memory": "1Gi"<br/>  }<br/>}</pre> | no |
| <a name="input_container_app_environment_name"></a> [container\_app\_environment\_name](#input\_container\_app\_environment\_name) | If set, this container app environment will be used to deploy the container app job. If not set, a new container app environment will be created. | `string` | `null` | no |
| <a name="input_docker_registry_password"></a> [docker\_registry\_password](#input\_docker\_registry\_password) | Docker registry password. Get this value from Orchestra's team. | `string` | n/a | yes |
| <a name="input_docker_registry_server"></a> [docker\_registry\_server](#input\_docker\_registry\_server) | The URL of Orchestra's region-specific docker registry. Get this value from Orchestra's team. | `string` | n/a | yes |
| <a name="input_docker_registry_username"></a> [docker\_registry\_username](#input\_docker\_registry\_username) | Docker registry username. Get this value from Orchestra's team. | `string` | n/a | yes |
| <a name="input_federated_credential_audience"></a> [federated\_credential\_audience](#input\_federated\_credential\_audience) | Used to configure authentication within your Azure account. Get this value from Orchestra's team. | `string` | n/a | yes |
| <a name="input_federated_credential_subject_id"></a> [federated\_credential\_subject\_id](#input\_federated\_credential\_subject\_id) | Used to configure authentication within your Azure account. Get this value from Orchestra's team. | `string` | n/a | yes |
| <a name="input_image_tags"></a> [image\_tags](#input\_image\_tags) | A map representing the ACR image tags to use for each integration. | `map(string)` | <pre>{<br/>  "dbt_core": "2025.12.01-0",<br/>  "python": "2025.12.01-0"<br/>}</pre> | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | The integrations to deploy. Valid values are 'dbt\_core' and 'python'. | `list(string)` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix to use for the resources created by this module. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to deploy the Azure Container App Job into. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_orchestra_compute_resource_inputs"></a> [orchestra\_compute\_resource\_inputs](#output\_orchestra\_compute\_resource\_inputs) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Paste this value into the "Resource Group Name" field in Orchestra |
| <a name="output_unique_identifier"></a> [unique\_identifier](#output\_unique\_identifier) | Paste this value into the "Unique Identifier" field in Orchestra |
<!-- END_TF_DOCS -->
