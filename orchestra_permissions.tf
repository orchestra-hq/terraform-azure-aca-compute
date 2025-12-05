resource "azuread_application" "this" {
  display_name = "${var.name_prefix}-app-registration-${local.suffix}"
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id

  feature_tags {
    enterprise = true
  }
}

resource "azuread_application_federated_identity_credential" "this" {
  application_id = azuread_application.this.id
  display_name   = "${var.name_prefix}-federated-credential-${local.suffix}"
  description    = "Federated credentials used to grant Orchestra access to this account's Azure resources for hybrid compute"

  issuer    = local.federated_credentials_issuer
  audiences = [var.federated_credential_audience]
  subject   = var.federated_credential_subject_id
}

resource "azurerm_role_assignment" "container_app_job_resource_group" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Container Apps Jobs Contributor"
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

resource "azurerm_role_assignment" "log_analytics_contributor" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = azuread_service_principal.this.object_id
}
