variable "orchestra_api_key" {
  type      = string
  sensitive = true
}

variable "docker_registry_server" {
  type      = string
  sensitive = true
}

variable "docker_registry_username" {
  type      = string
  sensitive = true
}

variable "docker_registry_password" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "image_tags" {
  type = map(string)
}
