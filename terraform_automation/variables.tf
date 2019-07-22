variable "project" {
  description = "Project ID"
  type        = "string"
  default   = "kubernetes-learning-232815"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = "string"
  default        = "mlozano"
}

variable "my_public_ip" {
  description = "My public IP address"
  type        = "string"
  default        = "163.158.212.238"
}

variable "gcp_region" {
  description = "GCP Region"
  type        = "string"
  default        = "europe-west1"
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

