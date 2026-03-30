module "this" {
  source  = "orchestra-hq/aca-compute/azure"
  version = "1.0.0"

  name_prefix                    = "orchestra-compute"
  resource_group_name            = "hybrid-compute-examples-standard"
  container_app_environment_name = "your-private-environment"

  orchestra_credentials_api_endpoint = var.orchestra_credentials_api_endpoint
  orchestra_api_key                  = var.orchestra_api_key
  image_tags                         = var.image_tags

  container_app_job_env_vars = {
    EXAMPLE_KEY = "example_key"
  }

  container_app_job_secret_env_vars = {
    EXAMPLE_SECRET_VALUE = "example_secret_value"
  }
}
