locals {
  integrations     = [for k in var.integrations : lower(k)]
  python_versions  = ["3_12", "3_11"]
  package_managers = ["PIP", "POETRY", "UV"]
  task_defs = flatten([
    for integration in local.integrations : [
      for python_version in local.python_versions : [
        for package_manager in local.package_managers : {
          integration     = integration
          python_version  = python_version
          package_manager = package_manager
          cpu             = var.compute_resources[integration].cpu
          memory          = var.compute_resources[integration].memory
        }
      ]
    ]
  ])
}

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

  name                = "${var.name_prefix}-log-analytics-${local.suffix}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  count = local.create_container_app_environment ? 1 : 0

  name                       = "${var.name_prefix}-aca-env-${local.suffix}"
  location                   = data.azurerm_resource_group.this.location
  resource_group_name        = data.azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id
}

resource "azurerm_container_app_job" "this" {
  for_each = { for task in local.task_defs : "${replace(task.integration, "_", "-")}-${replace(task.python_version, "_", "-")}-${lower(task.package_manager)}" => task }

  name                         = "orc-${each.key}-${local.suffix}"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  container_app_environment_id = local.container_app_environment_id
  replica_timeout_in_seconds   = 1800 # TODO - ENG-7994 - Decide this
  # workload_profile_name        = "Consumption" # TODO - Figure out if this is needed in certain subscription types

  manual_trigger_config { # TODO - ENG-7994 - Decide this
    parallelism              = 1
    replica_completion_count = 1
  }

  registry {
    server               = var.docker_registry_server
    username             = var.docker_registry_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = var.docker_registry_password
  }

  template {
    container {
      image  = "${var.docker_registry_server}/${each.value.integration}:${each.value.python_version}_${upper(each.value.package_manager)}-${var.image_tags[each.value.integration]}"
      name   = "compute-runner"
      cpu    = var.compute_resources[each.value.integration].cpu
      memory = var.compute_resources[each.value.integration].memory
    }
  }
}
