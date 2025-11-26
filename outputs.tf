output "app_registration_name" {
  value       = azuread_application.this.display_name
  description = "App registration"
}

output "service_principal_name" {
  value       = azuread_service_principal.this.display_name
  description = "Service principal"
}

output "federated_credential_name" {
  value       = azuread_application_federated_identity_credential.this.display_name
  description = "Federated credentials"
}
