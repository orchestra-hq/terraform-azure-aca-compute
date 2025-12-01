output "resource_group_name" {
  value       = azurerm_container_app_job.this.resource_group_name
  description = "Paste this value into the \"Resource Group Name\" field in Orchestra"
}

output "unique_identifier" {
  value       = "${var.name_prefix}-compute-${local.suffix}"
  description = "Paste this value into the \"Unique Identifier\" field in Orchestra"
}

output "orchestra_compute_resource_inputs" {
  value = <<-EOT
Enter the following values in the Orchestra UI:
- Resource Group: ${azurerm_container_app_job.this.resource_group_name}
- Unique Identifier: ${var.name_prefix}-compute-${local.suffix}
EOT
}
