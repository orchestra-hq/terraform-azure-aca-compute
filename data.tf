data "http" "federated_credentials" {
  count = var.enterprise_app_name == "" ? 1 : 0

  url = "${trim(var.orchestra_api_base_url, "/")}/api/engine/public/compute_resources/azure/federated_credentials"

  request_headers = {
    Authorization = "Bearer ${var.orchestra_api_key}"
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch federated credentials from Orchestra API (HTTP ${self.status_code}). Check that your orchestra_api_key is valid."
    }
  }
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}
