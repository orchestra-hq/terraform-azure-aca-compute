variable "name_prefix" {
  description = "The name prefix to use for most resources created by this module."
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 40
    error_message = "The name prefix must be 40 characters or fewer."
  }
  validation {
    condition     = length(var.name_prefix) >= 5
    error_message = "The name prefix must be at least 5 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name_prefix))
    error_message = "The name prefix must only contain lowercase letters, numbers, and hyphens (-)."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy the Azure Container App Job into."
  type        = string
}

variable "container_app_environment_name" {
  description = "If set, this container app environment will be used to deploy the container app job. If not set, a new container app environment will be created."
  type        = string
  default     = null
}

variable "integrations" {
  description = "The integrations to deploy. Valid values are 'dbt_core' and 'python'."
  type        = list(string)

  validation {
    condition     = alltrue([for integration in var.integrations : contains(["dbt_core", "python"], integration)])
    error_message = "The integrations must be one of 'dbt_core' or 'python'."
  }
}

variable "image_tags" {
  description = "A map representing the ACR image tags to use for each integration."
  type        = map(string)
  default = { # TODO - ENG-7994 - Update these once we have a version that can run on Azure
    python   = "2025.12.01-0",
    dbt_core = "2025.12.01-0"
  }
  validation {
    condition     = alltrue([for k in var.integrations : contains(keys(var.image_tags), lower(k))])
    error_message = "Each integration must have an image tag defined."
  }
}

variable "compute_resources" {
  description = "A map representing the compute resources (CPU and memory) to use for each integration."
  type = map(object({
    cpu    = number
    memory = number
  }))
  default = {
    python   = { cpu = "0.5", memory = "1Gi" }
    dbt_core = { cpu = "0.5", memory = "1Gi" }
  }
  validation {
    condition     = alltrue([for k in var.integrations : contains(keys(var.compute_resources), lower(k))])
    error_message = "Each integration must have compute resources defined."
  }
}

variable "tags" { # TODO - Set this up
  type        = map(string)
  description = "Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden)."

  default = {}
}

variable "federated_credential_subject_id" {
  description = "Used to configure authentication within your Azure account. Get this value from Orchestra's team."
  type        = string
}

variable "federated_credential_audience" {
  description = "Used to configure authentication within your Azure account. Get this value from Orchestra's team."
  type        = string
}

variable "docker_registry_server" {
  description = "The URL of Orchestra's region-specific docker registry. Get this value from Orchestra's team."
  type        = string
}

variable "docker_registry_username" {
  description = "Docker registry username. Get this value from Orchestra's team."
  type        = string
}

variable "docker_registry_password" {
  description = "Docker registry password. Get this value from Orchestra's team."
  type        = string
  sensitive   = true
}
