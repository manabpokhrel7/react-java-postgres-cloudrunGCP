resource "google_cloud_run_v2_service" "java" {
  name     = "java-api"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false

  template {

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [
          google_sql_database_instance.main.connection_name
        ]
      }
    }

    scaling {
      max_instance_count = 10
    }

    containers {
      name  = "java-container"
      image = "us-central1-docker.pkg.dev/thermal-camera-485502-u2/my-repository/java-springboot:v9"

      ports {
        container_port = 9090
      }

      resources {
        limits = {
          memory = "1Gi"
          cpu    = "1"
        }
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      # ===== DATABASE (Cloud SQL socket) =====
      env {
        name  = "DB_NAME"
        value = "mydb"
      }

      env {
        name  = "DB_USER"
        value = "manab"
      }

      env {
        name  = "DB_PASS"
        value = "strongpass"
      }

      env {
        name  = "CLOUD_SQL_INSTANCE"
        value = google_sql_database_instance.main.connection_name
      }

      # ===== RABBITMQ (CloudAMQP – managed) =====
      env {
        name  = "RABBITMQ_HOST"
        value = "woodpecker.rmq.cloudamqp.com"
      }

      env {
        name  = "RABBITMQ_PORT"
        value = "5672"   # TLS port
      }

      env {
        name  = "RABBITMQ_USER"
        value = "amluser"
      }

      env {
        name  = "RABBITMQ_PASSWORD"
        value = "amlpassword"
      }
    }
  }
  lifecycle {
    ignore_changes = [
      client,
      client_version,
    ]
  }
}

resource "google_cloud_run_v2_service" "react" {
  name     = "react-frontend"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"

  template {
    containers {
      name  = "react-container"
      image = "us-central1-docker.pkg.dev/thermal-camera-485502-u2/my-repository/react-springboot:latest"

      ports {
        container_port = 80
      }
    }
  }
  lifecycle {
    ignore_changes = [
      client,
      client_version,
    ]
  }
}