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
    start_time = optional(string, null),
    end_time   = optional(string, null),
    recurrence = optional(string, null)
  })
  default = {}
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