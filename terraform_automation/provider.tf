terraform {
  required_version = "~> 0.12.4"
}

provider "google" {
  project = "kubernetes-learning-232815"
  region  = "europe-west1"
}