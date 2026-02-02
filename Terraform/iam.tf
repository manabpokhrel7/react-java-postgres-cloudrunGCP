resource "google_cloud_run_v2_service_iam_member" "java_invoker" {
  name     = google_cloud_run_v2_service.java.name
  location = google_cloud_run_v2_service.java.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
resource "google_cloud_run_v2_service_iam_member" "react_invoker" {
  name     = google_cloud_run_v2_service.react.name
  location = google_cloud_run_v2_service.react.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}