resource "google_artifact_registry_repository" "go_service" {
  location      = var.gcp_region
  repository_id = "${var.project_name}-go"
  description   = "Go service container images"
  format        = "DOCKER"
}

resource "google_artifact_registry_repository" "swift_service" {
  location      = var.gcp_region
  repository_id = "${var.project_name}-swift"
  description   = "Swift service container images"
  format        = "DOCKER"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_name}-gke"
  location = var.gcp_zone

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.project_name}-node-pool"
  location   = var.gcp_zone
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    machine_type = "t2a-standard-1"
    disk_size_gb = 20

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}