resource "google_compute_firewall" "ssh" {
  name    = "fw-allow-ssh"
  project = "${var.project}"
  network = "${google_compute_network.vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.my_public_ip}/32"]
}

resource "google_compute_firewall" "https" {
  name    = "fw-allow-https"
  project = "${var.project}"
  network = "${google_compute_network.vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["${var.my_public_ip}/32"]
}

resource "google_compute_firewall" "icmp" {
  name    = "fw-allow-icmp"
  project = "${var.project}"
  network = "${google_compute_network.vpc_network.name}"

  allow {
    protocol = "icmp"
  }

  source_ranges = ["${var.my_public_ip}/32"]
}

resource "google_compute_firewall" "allow-internal" {
  name    = "fw-allow-internal"
  project = "${var.project}"
  network = "${google_compute_network.vpc_network.name}"

  allow {
    protocol = "all"
  }

  source_ranges = [
    "${google_compute_subnetwork.gke_subnet.ip_cidr_range}",
    "${google_compute_subnetwork.gke_subnet.secondary_ip_range.0.ip_cidr_range}",
    "${google_compute_subnetwork.gke_subnet.secondary_ip_range.1.ip_cidr_range}"
  ]
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "subnet-${var.cluster_name}"
  ip_cidr_range = "${lookup(var.subnet_ip_range, "default")}"
  region        = "${var.gcp_region}"
  network       = "${google_compute_network.vpc_network.self_link}"

  secondary_ip_range {
    range_name    = "${var.gcp_region}-01-gke-01-pods"
    ip_cidr_range = "${lookup(var.subnet_ip_range, "${var.gcp_region}-01-gke-01-pods")}"
  }
  secondary_ip_range {
    range_name    = "${var.gcp_region}-01-gke-01-services"
    ip_cidr_range = "${lookup(var.subnet_ip_range, "${var.gcp_region}-01-gke-01-services")}"
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-${var.cluster_name}"
  description             = "VPC for GKE cluster"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
  project                 = "${var.project}"
}
