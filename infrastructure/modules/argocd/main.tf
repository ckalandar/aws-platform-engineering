resource "kubernetes_namespace" "argocd" {

  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  chart   = "argo-cd"
  version = "8.3.1"

  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false

  wait    = true
  timeout = 900

  depends_on = [
    kubernetes_namespace.argocd
  ]
}

resource "kubectl_manifest" "root_app" {

  depends_on = [
    helm_release.argocd
  ]

  yaml_body = file(var.root_app_path)
}