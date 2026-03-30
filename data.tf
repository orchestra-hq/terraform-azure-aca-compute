data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "http" "orchestra_credentials" {
  url = var.orchestra_credentials_api_endpoint

  request_headers = {
    Authorization = "Bearer ${var.orchestra_api_key}"
    Accept        = "application/json"
  }
}

check "orchestra_credentials_api_response" {
  assert {
    condition     = data.http.orchestra_credentials.status_code == 200
    error_message = "The Orchestra credentials API call failed. Expected HTTP 200, got ${data.http.orchestra_credentials.status_code}."
  }

  assert {
    condition     = can(jsondecode(data.http.orchestra_credentials.response_body))
    error_message = "The Orchestra credentials API response must be valid JSON."
  }

  assert {
    condition = alltrue([
      trimspace(try(local.orchestra_credentials_response.docker_registry_server, "")) != "",
      trimspace(try(local.orchestra_credentials_response.docker_registry_username, "")) != "",
      trimspace(try(local.orchestra_credentials_response.docker_registry_password, "")) != "",
    ])
    error_message = "The Orchestra credentials API response must include non-empty docker_registry_server, docker_registry_username, and docker_registry_password fields."
  }

  assert {
    condition = var.enterprise_app_name != "" || alltrue([
      trimspace(try(local.orchestra_credentials_response.federated_credential_subject_id, "")) != "",
      trimspace(try(local.orchestra_credentials_response.federated_credential_audience, "")) != "",
    ])
    error_message = "The Orchestra credentials API response must include non-empty federated_credential_subject_id and federated_credential_audience fields when enterprise_app_name is not set."
  }
}
