resource "google_dns_managed_zone" "joomla-external-dns" {
  name        = "${lookup(var.dns_zones_name, "joomla")}"
  dns_name    = "${lookup(var.dns_name, "joomla")}"
  description = "Automatically managed zone by kubernetes.io/external-dns"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

resource "google_dns_managed_zone" "k8s-dashboard-external-dns" {
  name        = "${lookup(var.dns_zones_name, "k8s-dashboard")}"
  dns_name    = "${lookup(var.dns_name, "k8s-dashboard")}"
  description = "Automatically managed zone by kubernetes.io/external-dns"
  visibility  = "public"
  dnssec_config {
    state = "on"
  }
}

output "joomla_dns_name_servers" {
  value = "${google_dns_managed_zone.joomla-external-dns}"
}

output "k8s_dashboard_dns_name_servers" {
  value = "${google_dns_managed_zone.k8s-dashboard-external-dns}"
}
