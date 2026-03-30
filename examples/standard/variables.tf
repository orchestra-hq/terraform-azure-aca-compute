variable "orchestra_api_key" {
  type      = string
  sensitive = true
}

variable "orchestra_credentials_api_endpoint" {
  type = string
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
