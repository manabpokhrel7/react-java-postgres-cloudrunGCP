variable "cloudamqp_apikey" {
  type      = string
  sensitive = true
}

provider "cloudamqp" {
  apikey = var.cloudamqp_apikey
}

resource "cloudamqp_instance" "rabbitmq" {
  name   = "aml-rabbitmq"
  plan   = "lemur"
  region = "google-compute-engine::us-central1"
}