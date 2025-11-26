locals {
  name                         = "orchestra-${var.name_prefix}-${random_id.random_suffix.hex}"
  federated_credentials_issuer = "https://cognito-identity.amazonaws.com"
}

resource "random_id" "random_suffix" {
  byte_length = 4
}
