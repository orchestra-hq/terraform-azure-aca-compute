data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_container_app_environment" "this" {
  count = local.create_container_app_environment ? 0 : 1

  name                = var.container_app_environment_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "this" {
  count = local.create_container_app_environment ? 1 : 0

  name                = local.name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  count = local.create_container_app_environment ? 1 : 0

  name                       = local.name
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id
}

resource "azurerm_container_app_job" "this" {
  name                         = substr(local.name, 0, 32)
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  container_app_environment_id = local.container_app_environment_id
  replica_timeout_in_seconds   = 1800 # TODO - Set this

  manual_trigger_config {
    parallelism              = 1 # TODO - Set this
    replica_completion_count = 1 # TODO - Set this
  }

  registry {
    server               = var.docker_image_access.server
    username             = var.docker_image_access.username
    password_secret_name = var.docker_image_access.password_secret_name
  }

  secret {
    name  = "registry-password"
    value = "placeholder_password"
  }

  template {
    container {
      image  = "${var.image.name}:${var.image.tag}"
      name   = "compute-runner"
      cpu    = var.image.cpu
      memory = var.image.memory
    }
  }
}
