output "app_registration_name" {
  value       = module.this.app_registration_name
  description = "The name of the app registration"
}

output "service_principal_name" {
  value       = module.this.service_principal_name
  description = "The name of the service principal"
}

output "federated_credential_name" {
  value       = module.this.federated_credential_name
  description = "The name of the federated credential"
}
