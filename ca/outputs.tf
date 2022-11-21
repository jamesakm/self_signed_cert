output "gdp_ca_cert" {
 value = "${tls_locally_signed_cert.gdp.cert_pem}"
 sensitive = true
}
