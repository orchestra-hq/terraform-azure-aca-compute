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

  name         = "${var.name_prefix}-key-integration-${replace(each.key, "_", "-")}-${local.suffix}"
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey"
  ]

  depends_on = [azurerm_role_assignment.key_vault_crypto_officer]
}

resource "azurerm_storage_account" "credential_management" {
  name                     = "orcsecrets${local.suffix}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = false
  }
}

resource "azurerm_storage_container" "credential_management" {
  name                  = "${var.name_prefix}-orchestra-secrets-${local.suffix}"
  storage_account_id    = azurerm_storage_account.credential_management.id
  container_access_type = "private"
}
