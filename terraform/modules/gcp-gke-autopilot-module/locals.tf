locals {
  short_environment = var.environment == "nonprod" ? "np" : var.environment == "prod" ? "pr" : "sbx"
  identifier        = "${var.tier}-${var.environment}-${var.name}"
}