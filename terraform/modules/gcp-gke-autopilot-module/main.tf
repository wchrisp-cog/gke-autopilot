module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 31.0"

  deletion_protection = var.deletion_protection

  project_id  = var.project_id
  name        = local.identifier
  description = var.description
  regional    = true
  region      = var.region

  release_channel           = var.release_channel
  kubernetes_version        = var.kubernetes_version
  notification_config_topic = var.notification_config_topic
  maintenance_start_time    = var.maintenance_period.start_time
  maintenance_end_time      = var.maintenance_period.end_time
  maintenance_recurrence    = var.maintenance_period.recurrence
  maintenance_exclusions    = var.maintenance_exclusions

  network_project_id         = var.network_project_id
  network                    = var.network
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  master_authorized_networks = var.master_authorized_networks
  enable_private_endpoint    = true
  enable_private_nodes       = true
  network_tags               = var.network_tags
  configure_ip_masq          = var.configure_ip_masq
  non_masquerade_cidrs       = var.non_masquerade_cidrs

  http_load_balancing             = var.http_load_balancing
  gateway_api_channel             = var.gateway_api_channel
  enable_vertical_pod_autoscaling = true
  database_encryption             = var.database_encryption
  workload_config_audit_mode      = var.workload_config_audit_mode
  workload_vulnerability_mode     = var.workload_vulnerability_mode

  fleet_project                     = var.fleet_project
  fleet_project_grant_service_agent = var.fleet_project_grant_service_agent
}