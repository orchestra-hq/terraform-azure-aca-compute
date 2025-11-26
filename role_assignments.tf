resource "azurerm_role_assignment" "container_app_job" {
  scope                = azurerm_container_app_job.this.id
  role_definition_name = "Container Apps Jobs Operator"
  principal_id         = azuread_service_principal.this.object_id
}
