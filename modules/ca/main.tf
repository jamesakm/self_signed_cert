# Creates a private key in PEM format
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "gdp_csr" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  subject {
    # The subject CN field here contains the hostname to secure
    common_name = var.common_name
    country = var.country
    locality = var.locality
    organization = var.organization
    organizational_unit = var.organizational_unit
  }
}

# Generates a TLS self-signed certificate using the private key
resource "tls_self_signed_cert" "self_signed_cert" {
  private_key_pem = tls_private_key.private_key.private_key_pem

  validity_period_hours = var.validity_period_hours

  subject {
    # The subject CN field here contains the hostname to secure
    common_name = var.common_name
    country = var.country
    locality = var.locality
    organization = var.organization
    organizational_unit = var.organizational_unit
  }

  allowed_uses = ["key_encipherment", "digital_signature", "server_auth"]

}

//CA certificate

resource "tls_locally_signed_cert" "gdp" {
  cert_request_pem   = tls_cert_request.gdp_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.private_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.self_signed_cert.cert_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

