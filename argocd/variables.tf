variable "argocd_namespace" {
  type    = string
  default = "infra-tools"
}

variable "argocd_chart_version" {
  type    = string
  default = "5.45.3"
}
