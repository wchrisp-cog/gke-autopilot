# K8s Network
module "gcp-network" {
  source  = "terraform-google-modules/network/google"
  version = ">= 7.5"

  project_id   = var.project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = "10.0.0.0/17"
      subnet_region         = var.region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    (local.subnet_name) = [
      {
        range_name    = local.pods_range_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.svc_range_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

#K8s Router/NAT for external network requests (Internet Access)
resource "google_compute_router" "router" {
  name    = "${local.network_name}-router"
  project = module.gcp-network.project_id
  region  = var.region
  network = module.gcp-network.network_id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${local.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  project                            = google_compute_router.router.project
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# K8s Cluster
module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 30.0"

  project_id                      = var.project_id
  name                            = var.cluster_name
  regional                        = true
  region                          = var.region
  kubernetes_version              = var.kubernetes_version
  network_project_id              = module.gcp-network.project_id
  network                         = module.gcp-network.network_name
  subnetwork                      = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods                   = local.pods_range_name
  ip_range_services               = local.svc_range_name
  release_channel                 = var.release_channel
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  network_tags                    = var.network_tags
  deletion_protection             = var.deletion_protection
  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.kubernetes_secrets.id
  }]

  master_authorized_networks = [
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]

  maintenance_start_time = var.maintenance_period.start_time
  maintenance_end_time   = var.maintenance_period.end_time
  maintenance_recurrence = var.maintenance_period.recurrence
  maintenance_exclusions = var.maintenance_exclusions

}

resource "google_kms_key_ring" "kubernetes_secrets" {
  name     = "${var.cluster_name}-kms-key-ring"
  location = var.region
}

resource "google_kms_crypto_key" "kubernetes_secrets" {
  name            = "${var.cluster_name}-kms-key"
  key_ring        = google_kms_key_ring.kubernetes_secrets.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_binding" "kubernetes_secrets" {
  crypto_key_id = google_kms_crypto_key.kubernetes_secrets.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${module.gke.service_account}",
    "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
  ]
}
