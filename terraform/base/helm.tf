# cert-manager resources

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.0.1"
  namespace  = "kube-system"
  timeout    = 120
  depends_on = [
    kubernetes_ingress.cluster_ingress,
  ]
  set {
    name  = "createCustomResource"
    value = "true"
  }
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "cluster_issuer" {
  name      = "cluster-issuer"
  chart     = "../helm_charts/cluster-issuer"
  namespace = "kube-system"
  depends_on = [
    helm_release.cert_manager,
  ]
  set {
    name  = "letsencrypt_email"
    value = var.letsencrypt_email
  }
}

resource "helm_release" "nginx_ingress_chart" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "service.annotations.kubernetes\\.digitalocean\\.com/load-balancer-id"
    value = digitalocean_loadbalancer.ingress_load_balancer.id
  }
  depends_on = [
    digitalocean_loadbalancer.ingress_load_balancer,
  ]
}
