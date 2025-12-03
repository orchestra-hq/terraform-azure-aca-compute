resource "azurerm_key_vault" "this" {
  name                = "orc-secrets-kv-${local.suffix}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                   = "standard"
  soft_delete_retention_days = 30
  purge_protection_enabled   = false
  rbac_authorization_enabled = true
}

resource "azurerm_key_vault_key" "credential_encryption" {
  for_each = toset(local.integrations)

  name         = "${var.name_prefix}-integration-${replace(each.key, "_", "-")}-${local.suffix}"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey"
  ]

  depends_on = [azurerm_role_assignment.secrets_management, azurerm_role_assignment.secrets_management_current_user]
}
