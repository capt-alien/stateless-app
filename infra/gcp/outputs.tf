output "gcp_project_id" {
  value = var.gcp_project_id
}

output "gcp_region" {
  value = var.gcp_region
}

output "go_artifact_repository" {
  value = google_artifact_registry_repository.go_service.name
}

output "swift_artifact_repository" {
  value = google_artifact_registry_repository.swift_service.name
}

output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_location" {
  value = google_container_cluster.primary.location
}