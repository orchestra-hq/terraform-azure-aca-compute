output "orchestra_compute_resource_inputs" {
  value = <<-EOT
Enter the following values in the Orchestra UI:
- Tenant ID: ${data.azurerm_client_config.current.tenant_id}
- Subscription ID: ${data.azurerm_subscription.current.subscription_id}
- Client ID: ${azuread_application.this.client_id}
- Unique Identifier: ${var.name_prefix}-compute-${local.suffix}
- Resource group name: ${var.resource_group_name}
- Container app environment id: ${local.container_app_environment_id}
EOT
}
