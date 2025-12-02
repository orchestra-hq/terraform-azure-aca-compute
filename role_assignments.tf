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

resource "azurerm_role_assignment" "secrets_management_current_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
