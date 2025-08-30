provider "kubernetes" {}

provider "helm" {
  kubernetes = {}
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "infra-tools"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  version    = "5.45.3"
  values     = [file("${path.module}/values/argocd-values.yaml")]
  wait       = true
}

