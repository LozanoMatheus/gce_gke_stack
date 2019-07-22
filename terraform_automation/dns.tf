resource "google_dns_managed_zone" "joomla-external-dns" {
  name        = "${lookup(var.dns_zones_name, "joomla")}"
  dns_name    = "joomla.lozanomatheus.com."
  description = "Automatically managed zone by kubernetes.io/external-dns"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

resource "google_dns_managed_zone" "k8s-dashboard-external-dns" {
  name        = "${lookup(var.dns_zones_name, "k8s-dashboard")}"
  dns_name    = "k8s-dashboard.lozanomatheus.com."
  description = "Automatically managed zone by kubernetes.io/external-dns"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

output "dns_name_servers" {
  value = "${google_dns_managed_zone.gke-external-dns}"
}
