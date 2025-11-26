variable "name_prefix" {
  description = "The name prefix to use for the resources created by this module."
  type        = string

  validation {
    condition     = length(var.name_prefix) <= 25
    error_message = "The name prefix must be less than 25 characters."
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

variable "orchestra_account_id" {
  description = "Your Orchestra account ID, which can be found in the Account Settings page on Orchestra."
  type        = string
}

variable "federated_credentials" {
  description = "Set the subject and audience values for the federated credentials, which can be found in the Orchestra UI during Compute Resource set-up."
  type = object({
    subject  = string
    audience = string
  })
}

variable "resource_group_name" {
  description = "Name of the resource group to deploy the Azure Container App Job into."
  type        = string
}

variable "container_app_environment_name" {
  description = "If set, this container app environment will be used to deploy the container app job. If not set, a new container app environment will be created. e.g. \"test-environment\""
  type        = string
  default     = null
}

variable "tags" { # TODO - Set this up
  type        = map(string)
  description = "Tags to apply to all deployed resources ('Application' and 'DeployedBy' are included by default but can be overridden)."

  default = {}
}

variable "docker_image_access" {
  description = "Docker image access credentials, which can be found in the Orchestra UI during Compute Resource set-up."
  type = object({
    server               = string
    username             = string
    password_secret_name = string
  })
  sensitive = true
  default = {
    server               = "docker.io"
    username             = "placeholder_username"
    password_secret_name = "registry-password"
  }
}

variable "image" {
  description = "The image to be used for the container app job."
  type = object({
    name   = string
    tag    = string
    cpu    = string
    memory = string
  })
  default = {
    name   = "nginx"
    tag    = "latest"
    cpu    = "0.5"
    memory = "1Gi"
  }
}
