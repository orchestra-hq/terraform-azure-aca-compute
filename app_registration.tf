resource "azuread_application" "this" {
  display_name = local.name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id

  feature_tags { # TODO - check if it has to be enterprise
    enterprise = true
  }
}

resource "azuread_application_federated_identity_credential" "this" {
  application_id = azuread_application.this.id
  display_name   = local.name
  description    = "Federated credentials used to grant Orchestra access to this account's Azure resources for hybrid compute"

  issuer    = local.federated_credentials_issuer
  audiences = [var.federated_credentials.audience]
  subject   = var.federated_credentials.subject
}
