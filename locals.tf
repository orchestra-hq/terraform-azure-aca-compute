locals {
  suffix                           = random_id.random_suffix.hex
  create_container_app_environment = var.container_app_environment_name == null
  location                         = local.create_container_app_environment ? data.azurerm_resource_group.this.location : data.azurerm_container_app_environment.this[0].location
  container_app_environment_id     = local.create_container_app_environment ? azurerm_container_app_environment.this[0].id : data.azurerm_container_app_environment.this[0].id
  normalized_secret_names = {
    for key, value in var.container_app_job_secret_env_vars :
    key => replace(lower(key), "_", "-")
  }
  tags = merge(
    {
      Application = "Orchestra Technologies"
      DeployedBy  = "Terraform"
    },
    var.tags,
  )

  federated_credentials_issuer = "https://cognito-identity.amazonaws.com"
  service_principal_object_id  = var.enterprise_app_object_id == "" ? azuread_service_principal.this[0].object_id : var.enterprise_app_object_id
  azure_client_id_output_value = var.enterprise_app_object_id == "" ? azuread_application.this[0].client_id : "Set the Client ID of the Enterprise Application that was manually created"
}

resource "random_id" "random_suffix" {
  byte_length = 3
}
