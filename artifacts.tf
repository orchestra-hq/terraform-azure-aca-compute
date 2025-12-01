resource "azurerm_storage_account" "artifacts" {
  name                     = "orcartifacts${local.suffix}"
  resource_group_name      = data.azurerm_resource_group.this.name
  location                 = data.azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = false
  }
}

resource "azurerm_storage_container" "artifacts" {
  name                  = "${var.name_prefix}-orchestra-artifacts-${local.suffix}"
  storage_account_id    = azurerm_storage_account.artifacts.id
  container_access_type = "private"
}
