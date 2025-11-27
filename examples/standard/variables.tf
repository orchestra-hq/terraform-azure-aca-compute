variable "federated_credentials" {
  type      = any
  sensitive = true
}

variable "docker_registry_password" {
  type      = string
  sensitive = true
}
