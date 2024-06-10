resource "helm_release" "release" {
  for_each = var.helm_release

  name       = each.key
  repository = each.value.repository
  chart      = each.value.chart
  version    = each.value.version
  lint       = true

  depends_on = [module.gke]
}