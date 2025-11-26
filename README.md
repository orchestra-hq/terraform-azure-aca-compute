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
| [random_id.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurerm_container_app_environment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_app_environment) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_app_environment_name"></a> [container\_app\_environment\_name](#input\_container\_app\_environment\_name) | If set, this container app environment will be used to deploy the container app job. If not set, a new container app environment will be created. e.g. "test-environment" | `string` | `null` | no |
| <a name="input_docker_image_access"></a> [docker\_image\_access](#input\_docker\_image\_access) | Docker image access credentials, which can be found in the Orchestra UI during Compute Resource set-up. | <pre>object({<br/>    server   = string<br/>    username = string<br/>    password = string<br/>  })</pre> | n/a | yes |
| <a name="input_federated_credentials"></a> [federated\_credentials](#input\_federated\_credentials) | Set the subject and audience values for the federated credentials, which can be found in the Orchestra UI during Compute Resource set-up. | <pre>object({<br/>    subject  = string<br/>    audience = string<br/>  })</pre> | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix to use for the resources created by this module. | `string` | n/a | yes |
| <a name="input_orchestra_account_id"></a> [orchestra\_account\_id](#input\_orchestra\_account\_id) | Your Orchestra account ID, which can be found in the Account Settings page on Orchestra. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group to deploy the Azure Container App Job into. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden). | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_registration_name"></a> [app\_registration\_name](#output\_app\_registration\_name) | App registration |
| <a name="output_federated_credential_name"></a> [federated\_credential\_name](#output\_federated\_credential\_name) | Federated credentials |
| <a name="output_service_principal_name"></a> [service\_principal\_name](#output\_service\_principal\_name) | Service principal |
<!-- END_TF_DOCS -->
