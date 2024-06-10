# K8s Cluster
module "gke" {
  source = "./modules/gcp-gke-autopilot-module"

  project_id                        = var.project_id
  name                              = var.cluster_name
  tier                              = var.tier
  environment                       = var.environment
  region                            = var.region
  fleet_project                     = var.fleet_project
  fleet_project_grant_service_agent = false

  release_channel    = var.release_channel
  kubernetes_version = var.kubernetes_version

  maintenance_period        = var.maintenance_period
  maintenance_exclusions    = var.maintenance_exclusions
  notification_config_topic = google_pubsub_topic.example.id

  network_project_id         = module.gcp-network.project_id
  network                    = module.gcp-network.network_name
  subnetwork                 = local.subnet_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  network_tags               = var.network_tags
  master_authorized_networks = var.master_authorized_networks
  configure_ip_masq          = false

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = google_kms_crypto_key.database_encryption.id
  }]

  deletion_protection = var.deletion_protection
}

##
#### EXTRA RESOURCES
##

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

#K8s Database encryption keys
resource "google_kms_key_ring" "database_encryption" {
  name     = "${var.cluster_name}-kms-key-ring"
  location = var.region
}

resource "google_kms_crypto_key" "database_encryption" {
  name            = "${var.cluster_name}-kms-key"
  key_ring        = google_kms_key_ring.database_encryption.id
  rotation_period = "7776000s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_kms_crypto_key_iam_binding" "database_encryption" {
  crypto_key_id = google_kms_crypto_key.database_encryption.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${module.gke.service_account}",
    "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
  ]
}

#K8s Upgrade notification pubsub
resource "google_pubsub_topic" "example" {
  name = "example-topic"

  labels = {
    foo = "bar"
  }

  message_retention_duration = "86600s"
}
