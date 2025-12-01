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
