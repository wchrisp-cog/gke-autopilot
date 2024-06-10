resource "helm_release" "release" {
  count      = length(var.helm_release)
  name       = var.helm_release[count.index].name
  repository = var.helm_release[count.index].repository
  chart      = var.helm_release[count.index].chart
  version    = var.helm_release[count.index].version
}