module "this" {
  source  = "orchestra-hq/aca-compute/azure"
  version = "~> 1.1"

  name_prefix                    = "orchestra-compute"
  resource_group_name            = "hybrid-compute-examples-standard"
  container_app_environment_name = "your-private-environment"

  orchestra_api_key = var.orchestra_api_key

  docker_registry_server   = var.docker_registry_server
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password
  image_tags               = var.image_tags

  container_app_job_env_vars = {
    EXAMPLE_KEY = "example_key"
  }

  container_app_job_secret_env_vars = {
    EXAMPLE_SECRET_VALUE = "example_secret_value"
  }
}
