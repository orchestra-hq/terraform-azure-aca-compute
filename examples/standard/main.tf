module "this" {
  source = "../../"

  name_prefix                    = "orchestra-compute"
  orchestra_account_id           = "1234567890"
  federated_credentials          = var.federated_credentials
  resource_group_name            = "hybrid-compute-dev"
  container_app_environment_name = "dev"

  docker_registry_server   = "orchestra-example-registry.azurecr.io"
  docker_registry_username = "username"
  docker_registry_password = var.docker_registry_password

  image = {
    name = "example-image"
    tag  = "v1.0.0"
  }

  container_resources = {
    cpu    = "0.5"
    memory = "1Gi"
  }
}
