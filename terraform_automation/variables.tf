variable "project" {
  description = "Project ID"
  type        = "string"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = "string"
}

variable "my_public_ip" {
  description = "My public IP address"
  type        = "string"
}

variable "dns_zones_name" {
  description = "Public DNS zone name"
  type        = "map"
  default = {
    "joomla"        = "joomla"
    "k8s-dashboard" = "k8s-dashboard"
  }
}

variable "dns_name" {
  description = "Public DNS name"
  type        = "map"
  default = {
    "joomla"        = "joomla.lozanomatheus.com."
    "k8s-dashboard" = "k8s-dashboard.lozanomatheus.com."
  }
}

variable "gcp_region" {
  description = "GCP Region"
  type        = "string"
}

variable "subnet_ip_range" {
  description = "IP range for GKE cluster"
  type        = "map"

  default = {
    "default"                         = "10.127.0.0/20"
    "europe-west1-01-gke-01-pods"     = "10.127.16.0/20"
    "europe-west1-01-gke-01-services" = "10.127.32.0/20"
  }
}

