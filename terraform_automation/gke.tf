module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "${var.project}"
  name                       = "${var.cluster_name}"
  regional                   = true
  region                     = "${var.gcp_region}"
  zones                      = ["europe-west1-b", "europe-west1-d", "europe-west1-c"]
  network                    = "${google_compute_network.vpc_network.name}"
  subnetwork                 = "${google_compute_subnetwork.gke_subnet.name}"
  ip_range_pods              = "${var.gcp_region}-01-gke-01-pods"
  ip_range_services          = "${var.gcp_region}-01-gke-01-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = false
  network_policy             = true
  remove_default_node_pool   = true
  initial_node_count         = 1

  node_pools = [
    {
      name            = "default-node-pool"
      machine_type    = "n1-standard-1"
      min_count       = 1
      max_count       = 3
      disk_size_gb    = 20
      disk_type       = "pd-standard"
      image_type      = "COS"
      auto_repair     = true
      auto_upgrade    = true
      service_account = "7989636060-compute@developer.gserviceaccount.com"
      preemptible     = true
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool-${var.cluster_name}"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = false
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
