
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_cert_request" "example" {
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
