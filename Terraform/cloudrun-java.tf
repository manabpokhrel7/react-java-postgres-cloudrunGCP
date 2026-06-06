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
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
      name  = "java-container"
      image = "us-central1-docker.pkg.dev/project-5cccd6a0-b034-4117-a60/my-repository/java-springboot:v9"

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
        name  = "RABBITMQ_URL"
        value = "amqps://mkswvofb:zbp2DoZm6cbWPim7rLfU9rqP0Bcom9Eo@shark.rmq.cloudamqp.com/mkswvofb"
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
  deletion_protection = false

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
      name  = "react-container"
      image = "us-central1-docker.pkg.dev/project-5cccd6a0-b034-4117-a60/my-repository/react-springboot:latest"

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
resource "google_cloud_run_v2_service" "onlyoffice" {
  name     = "onlyoffice-documentserver"
  location = "us-central1"
  ingress  = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = false

  template {

    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }

    containers {
      name  = "onlyoffice-container"
      image = "onlyoffice/documentserver:latest"

      ports {
        container_port = 80
      }

      env {
        name  = "JWT_ENABLED"
        value = "false"
      }

      env {
        name  = "ALLOW_PRIVATE_IP_ADDRESS"
        value = "true"
      }

      env {
        name  = "ALLOW_META_IP_ADDRESS"
        value = "true"
      }

      resources {
        limits = {
          memory = "2Gi"
          cpu    = "2"
        }
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