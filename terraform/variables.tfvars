cluster_name = "playground-test"
environment  = "nonprod"
tier         = "hsec"

deletion_protection = false
release_channel     = "STABLE"
# kubernetes_version  = "1.26.15-gke.1090000"


# Maintenance Period
maintenance_period = {
  start_time = "2024-05-26T10:00:00Z"
  end_time   = "2024-05-28T22:00:00Z"
  recurrence = "FREQ=MONTHLY"
}

# Maintenance Exclusions
maintenance_exclusions = [
  {
    name            = "Shutdown Period"
    start_time      = "2024-12-23T00:00:00Z"
    end_time        = "2025-01-03T00:00:00Z"
    exclusion_scope = "NO_UPGRADES"
  },
  {
    name            = "Easter"
    start_time      = "2024-12-23T00:00:00Z"
    end_time        = "2025-01-03T00:00:00Z"
    exclusion_scope = "NO_UPGRADES"
  },
  {
    name            = "Application Release"
    start_time      = "2024-12-23T00:00:00Z"
    end_time        = "2025-01-03T00:00:00Z"
    exclusion_scope = "NO_UPGRADES"
  },
  # {
  #   name            = "Public holiday"
  #   start_time      = "2024-06-23T00:00:00Z"
  #   end_time        = "2024-07-03T00:00:00Z"
  #   exclusion_scope = "NO_MINOR_UPGRADES"
  # },
  # {
  #   name            = "Application Release v2"
  #   start_time      = "2024-06-23T00:00:00Z"
  #   end_time        = "2024-07-03T00:00:00Z"
  #   exclusion_scope = "NO_MINOR_OR_NODE_UPGRADES"
  # }
]

master_authorized_networks = [
  {
    cidr_block   = "10.60.0.0/17"
    display_name = "VPC"
  },
]

helm_release = {
  argo-cd = {
    repository = "https://argoproj.github.io/argo-helm",
    chart      = "argo-cd",
    version    = "7.1.3"
  },
  external-secrets = {
    repository = "https://charts.external-secrets.io",
    chart      = "external-secrets/external-secrets",
    version    = "0.9.19"
  }
}