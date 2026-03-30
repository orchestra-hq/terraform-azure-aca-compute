# Maps to the App Registration
resource "azuread_application" "this" {
  count = var.enterprise_app_name == "" ? 1 : 0

  display_name = "${var.name_prefix}-app-registration-${local.suffix}"
}

# Maps to the Enterprise Application
resource "azuread_service_principal" "this" {
  count = var.enterprise_app_name == "" ? 1 : 0

  client_id = azuread_application.this[0].client_id
  feature_tags {
    enterprise = true
  }
}

data "azuread_service_principal" "this" {
  count = var.enterprise_app_name == "" ? 0 : 1

  display_name = var.enterprise_app_name
}

resource "azuread_application_federated_identity_credential" "this" {
  count = var.enterprise_app_name == "" ? 1 : 0

  application_id = azuread_application.this[0].id
  display_name   = "${var.name_prefix}-federated-credential-${local.suffix}"
  description    = "Federated credentials used to grant Orchestra access to this account's Azure resources for hybrid compute"

  issuer    = local.federated_credentials_issuer
  audiences = [local.federated_credentials.audience]
  subject   = local.federated_credentials.subject_id
}

resource "azurerm_role_assignment" "container_app_job_resource_group" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Container Apps Jobs Contributor"
  principal_id         = local.service_principal_object_id
}

resource "azurerm_role_assignment" "secrets_management" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Officer"
  principal_id         = local.service_principal_object_id
}

resource "azurerm_role_assignment" "storage_blob_data" {
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = local.service_principal_object_id
}

resource "azurerm_role_assignment" "log_analytics_contributor" {
  scope                = data.azurerm_resource_group.this.id
  role_definition_name = "Log Analytics Reader"
  principal_id         = local.service_principal_object_id
}
