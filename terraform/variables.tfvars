deletion_protection = false
release_channel = "REGULAR"

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
  {
    name            = "Public holiday"
    start_time      = "2024-06-23T00:00:00Z"
    end_time        = "2024-07-03T00:00:00Z"
    exclusion_scope = "NO_MINOR_UPGRADES"
  },
  {
    name            = "Application Release v2"
    start_time      = "2024-06-23T00:00:00Z"
    end_time        = "2024-07-03T00:00:00Z"
    exclusion_scope = "NO_MINOR_OR_NODE_UPGRADES"
  }
]