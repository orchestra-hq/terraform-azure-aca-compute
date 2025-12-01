locals {
  suffix                           = random_id.random_suffix.hex
  federated_credentials_issuer     = "https://cognito-identity.amazonaws.com"
  create_container_app_environment = var.container_app_environment_name == null
  container_app_environment_id     = local.create_container_app_environment ? azurerm_container_app_environment.this[0].id : data.azurerm_container_app_environment.this[0].id
}

resource "random_id" "random_suffix" {
  byte_length = 3
}
