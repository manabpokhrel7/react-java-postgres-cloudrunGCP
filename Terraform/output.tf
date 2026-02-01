output "gcp_artifact_registry" {
  value = google_artifact_registry_repository.my-repo.registry_uri
}

output "cloudrun_url" {
	value = google_cloud_run_v2_service.react.urls
}

output "cloudsql_connection_name" {
  value = google_sql_database_instance.main.connection_name
}

output "java_cloud_run_service_url" {
  value = google_cloud_run_v2_service.java.uri
}

output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.http.ip_address
}
