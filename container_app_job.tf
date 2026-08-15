locals {
  integrations = [for k in var.integrations : lower(k)]

  # Python-based integrations get one job per Python version and package manager.
  # Integrations that ship a single image (e.g. bash) get one job, keyed "default".
  matrix_integrations         = [for integration in local.integrations : integration if !contains(local.single_variant_integrations, integration)]
  single_variant_integrations = ["bash"]
  python_versions             = ["3_12", "3_11"]
  package_managers            = ["PIP", "POETRY", "UV"]

  matrix_task_defs = flatten([
    for integration in local.matrix_integrations : [
      for python_version in local.python_versions : [
        for package_manager in local.package_managers : {
          key            = "${replace(integration, "_", "-")}-${replace(python_version, "_", "-")}-${lower(package_manager)}"
          integration    = integration
          image_variant  = "${python_version}_${upper(package_manager)}"
          container_name = "compute-runner"
        }
      ]
    ]
  ])

  single_variant_task_defs = [
    for integration in local.integrations : {
      key            = "${replace(integration, "_", "-")}-default"
      integration    = integration
      image_variant  = "default"
      container_name = integration
    } if contains(local.single_variant_integrations, integration)
  ]

  task_defs = { for task in concat(local.matrix_task_defs, local.single_variant_task_defs) : task.key => task }
}

data "azurerm_container_app_environment" "this" {
  count = local.create_container_app_environment ? 0 : 1

  name                = var.container_app_environment_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_log_analytics_workspace" "this" {
  count = local.create_container_app_environment ? 1 : 0

  name                = "${var.name_prefix}-log-analytics-${local.suffix}"
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_container_app_environment" "this" {
  count = local.create_container_app_environment ? 1 : 0

  name                       = "${var.name_prefix}-aca-env-${local.suffix}"
  location                   = local.location
  resource_group_name        = data.azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id
  tags                       = local.tags
}

resource "azurerm_user_assigned_identity" "this" {
  for_each = local.task_defs

  name                = "orc-mi-${each.key}-${local.suffix}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}

resource "azurerm_container_app_job" "this" {
  for_each = local.task_defs

  name                         = "orc-${each.key}-${local.suffix}"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = local.location
  container_app_environment_id = local.container_app_environment_id
  replica_timeout_in_seconds   = var.aca_job_timeout_in_seconds
  tags                         = local.tags

  lifecycle {
    ignore_changes = [workload_profile_name]
  }

  # Parallelism refers to number of replicas per execution
  # We trigger separate executions per task run, so we set parallelism to 1
  manual_trigger_config {
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

  dynamic "secret" {
    for_each = var.container_app_job_secret_env_vars
    content {
      name  = local.normalized_secret_names[secret.key]
      value = secret.value
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this[each.key].id]
  }

  template {
    container {
      image  = "${var.docker_registry_server}/${replace(each.value.integration, "_", "-")}:${each.value.image_variant}-${var.image_tags[each.value.integration]}"
      name   = each.value.container_name
      cpu    = var.compute_resources[each.value.integration].cpu
      memory = var.compute_resources[each.value.integration].memory

      dynamic "env" {
        for_each = var.container_app_job_env_vars
        content {
          name  = env.key
          value = env.value
        }
      }

      dynamic "env" {
        for_each = var.container_app_job_secret_env_vars
        content {
          name        = env.key
          secret_name = local.normalized_secret_names[env.key]
        }
      }

      env {
        name  = "ORCHESTRA_MANAGED_IDENTITY_CLIENT_ID"
        value = azurerm_user_assigned_identity.this[each.key].client_id
      }
    }
  }
}

resource "azurerm_role_assignment" "container_app_job_secrets_storage" {
  for_each = local.task_defs

  scope                = azurerm_storage_container.credential_management.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.this[each.key].principal_id
}

resource "azurerm_role_assignment" "container_app_job_artifacts_storage" {
  for_each = local.task_defs

  scope                = azurerm_storage_container.artifacts.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.this[each.key].principal_id
}

resource "azurerm_role_assignment" "container_app_job_key_vault_decrypt" {
  for_each = local.task_defs

  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_user_assigned_identity.this[each.key].principal_id
}
