locals {
  suffix                           = random_id.random_suffix.hex
  federated_credentials_issuer     = "https://cognito-identity.amazonaws.com"
  create_container_app_environment = var.container_app_environment_name == null
  container_app_environment = local.create_container_app_environment ? {
    id       = azurerm_container_app_environment.this[0].id,
    location = data.azurerm_resource_group.this.location
    } : {
    id       = data.azurerm_container_app_environment.this[0].id,
    location = data.azurerm_container_app_environment.this[0].location
  }

  tags = merge(
    {
      Application = "Orchestra Technologies"
      DeployedBy  = "Terraform"
    },
    var.tags,
  )

  normalized_secret_names = {
    for key, value in var.container_app_job_secret_env_vars :
    key => replace(lower(key), "_", "-")
  }
}

resource "random_id" "random_suffix" {
  byte_length = 3
}
