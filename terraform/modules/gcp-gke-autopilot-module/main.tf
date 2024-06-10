module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 31.0"

  project_id                      = var.project_id
  name                            = local.identifier
  description                     = var.description
  regional                        = true
  region                          = var.region
  kubernetes_version              = var.kubernetes_version
  network_project_id              = var.network_project_id
  network                         = var.network
  subnetwork                      = var.subnetwork
  ip_range_pods                   = var.ip_range_pods
  ip_range_services               = var.ip_range_services
  release_channel                 = var.release_channel
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  network_tags                    = var.network_tags
  deletion_protection             = var.deletion_protection
  database_encryption             = var.database_encryption
  notification_config_topic       = var.notification_config_topic

  master_authorized_networks = var.master_authorized_networks

  maintenance_start_time = var.maintenance_period.start_time
  maintenance_end_time   = var.maintenance_period.end_time
  maintenance_recurrence = var.maintenance_period.recurrence
  maintenance_exclusions = var.maintenance_exclusions

  configure_ip_masq = var.configure_ip_masq

  fleet_project                     = var.fleet_project
  fleet_project_grant_service_agent = var.fleet_project_grant_service_agent
}