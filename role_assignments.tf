#####################################
##### Orchestra role assignments ####
#####################################

resource "azurerm_role_assignment" "container_app_job" {
  for_each = { for task in local.task_defs : "${replace(task.integration, "_", "-")}-${replace(task.python_version, "_", "-")}-${lower(task.package_manager)}" => task }

  scope                = azurerm_container_app_job.this[each.key].id
  role_definition_name = "Container Apps Jobs Operator"
  principal_id         = azuread_service_principal.this.object_id
}

resource "azurerm_role_assignment" "secrets_management" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = azuread_service_principal.this.object_id
}

resource "azurerm_role_assignment" "storage_blob_data" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.this.object_id
}

#####################################
### Current user role assignments ###
#####################################
resource "azurerm_role_assignment" "secrets_management_current_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

##########################################
### Container app job role assignments ###
##########################################

resource "azurerm_role_assignment" "container_app_job_secrets_storage" {
  for_each = { for task in local.task_defs : "${replace(task.integration, "_", "-")}-${replace(task.python_version, "_", "-")}-${lower(task.package_manager)}" => task }

  scope                = azurerm_storage_container.credential_management.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_container_app_job.this[each.key].identity[0].principal_id
}

resource "azurerm_role_assignment" "container_app_job_artifacts_storage" {
  for_each = { for task in local.task_defs : "${replace(task.integration, "_", "-")}-${replace(task.python_version, "_", "-")}-${lower(task.package_manager)}" => task }

  scope                = azurerm_storage_container.artifacts.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_container_app_job.this[each.key].identity[0].principal_id
}

resource "azurerm_role_assignment" "container_app_job_key_vault_decrypt" {
  for_each = { for task in local.task_defs : "${replace(task.integration, "_", "-")}-${replace(task.python_version, "_", "-")}-${lower(task.package_manager)}" => task }

  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = azurerm_container_app_job.this[each.key].identity[0].principal_id
}
