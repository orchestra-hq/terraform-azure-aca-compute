module "this" {
  source = "../../"

  name_prefix                    = "orchestra-compute"
  resource_group_name            = "hybrid-compute-examples-standard"
  container_app_environment_name = "private-subnet-environment"

  federated_credential_subject_id = var.federated_credential_subject_id
  federated_credential_audience   = var.federated_credential_audience

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
