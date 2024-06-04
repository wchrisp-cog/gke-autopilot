# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

data "google_compute_subnetwork" "subnet" {
  name       = local.subnet_name
  project    = var.project_id
  region     = var.region
  depends_on = [module.gcp-network]
}

data "google_project" "project" {
  project_id = var.project_id
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

