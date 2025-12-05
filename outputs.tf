output "orchestra_compute_resource_inputs" {
  value = <<-EOT
Enter the following values in the Orchestra UI:
- Compute resource identifier: ${var.name_prefix}-compute-${local.suffix}
- Resource group name: ${var.resource_group_name}
- Azure tenant ID: ${data.azurerm_client_config.current.tenant_id}
- Azure client ID: ${azuread_application.this.client_id}
- Azure subscription ID: ${data.azurerm_subscription.current.subscription_id}
EOT
}
