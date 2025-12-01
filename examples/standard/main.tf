module "this" {
  source = "../../"

  name_prefix                     = "orchestra-compute"
  resource_group_name             = "hybrid-compute-examples-standard"
  federated_credential_subject_id = var.federated_credential_subject_id
  federated_credential_audience   = var.federated_credential_audience

  docker_registry_server   = var.docker_registry_server
  docker_registry_username = var.docker_registry_username
  docker_registry_password = var.docker_registry_password

  integrations = ["python", "dbt_core"]

  image_tags = var.image_tags

  compute_resources = {
    python = {
      cpu    = "0.5"
      memory = "1Gi"
    }
    dbt_core = {
      cpu    = "0.5"
      memory = "1Gi"
    }
  }
}
