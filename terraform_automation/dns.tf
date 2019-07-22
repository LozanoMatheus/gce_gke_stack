resource "google_dns_managed_zone" "gke-external-dns" {
  name = "gke-external-dns"
  dns_name = "lozanomatheus.com."
  description = "Automatically managed zone by kubernetes.io/external-dns"
  visibility = "public"
  dnssec_config {
    state = "on"
  }
}

output "dns_name_servers" {
  value = "${google_dns_managed_zone.gke-external-dns}"
}
