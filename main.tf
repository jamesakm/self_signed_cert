
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


//CA module

module "certificate_authority" {
  source = "./modules/ca" 
    common_name = var.common_name
    country = var.country
    locality = var.locality
    organization = var.organization
    organizational_unit = var.organizational_unit
    validity_period_hours = var.validity_period_hours


}

output "gdp_private_key" {
 value = "${tls_private_key.private_key.private_key_pem}"
 sensitive = true
}

output "gdp_server_cert" {
 value = tls_self_signed_cert.self_signed_cert.cert_pem
 sensitive = true
}

output "gdp_csr_server-1" {
 value = tls_cert_request.gdp_csr.cert_request_pem
 sensitive = true
}

