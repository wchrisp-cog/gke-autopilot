variable "project_id" {
  description = "GCP Project to deploy to."
  type        = string
}

variable "region" {
  description = "GCP Region to deploy to."
  type        = string
}

variable "cluster_name" {
  description = "GCP GKE Cluster Name"
  type        = string
}

variable "tier" {
  description = "GCP GKE Cluster tier"
  type        = string
}

variable "environment" {
  description = "GCP GKE Cluster environment"
  type        = string
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the cluster."
  type        = bool
  default     = null
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version in the selected region."
  type        = string
  default     = null
}

variable "network_tags" {
  description = "(Optional) - List of network tags applied to auto-provisioned node pools."
  type        = list(string)
  default     = []
}

variable "maintenance_period" {
  description = "Time window specified for recurring maintenance"
  type = object({
    start_time = string,
    end_time   = string,
    recurrence = string
  })
  default = null
}

variable "maintenance_exclusions" {
  description = "List of maintenance exclusions. A cluster can have up to three"
  type = list(object({
    name       = string,
    start_time = string,
    end_time   = string,
  exclusion_scope = string }))
  default = []
}

variable "release_channel" {
  description = "The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE. Defaults to REGULAR."
  type        = string
  default     = null
}

variable "master_authorized_networks" {
  type        = list(object({ cidr_block = string, display_name = string }))
  description = "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
  default     = []
}

variable "fleet_project" {
  description = "(Optional) Register the cluster with the fleet in this project."
  type        = string
  default     = null
}

variable "helm_release" {
  description = "The helm releases you would like to deploy to the GKE Cluster"
  type = list(object({
    name       = string,
    repository = string,
    chart      = string,
    version    = string
  }))
  default = []
}
