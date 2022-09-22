resource "kubernetes_deployment" "deployments" {
  for_each = toset(var.top_level_domains)
  metadata {
    name      = "${replace(each.value, ".", "-")}-deployment"
    namespace = "default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "${replace(each.value, ".", "-")}-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "${replace(each.value, ".", "-")}-deployment"
        }
      }
      spec {
        container {
          image = "nginxdemos/hello"
          name  = "nginx-hello"
          port {
            container_port = 80
          }
          resources {
            limits = {
              memory = "512M"
              cpu    = "1"
            }
            requests = {
              memory = "256M"
              cpu    = "50m"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "services" {
  for_each = toset(var.top_level_domains)
  metadata {
    name      = "${replace(each.value, ".", "-")}-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "${replace(each.value, ".", "-")}-deployment"
    }
    port {
      port = 80
    }
  }
}

resource "kubernetes_ingress" "cluster_ingress" {
  depends_on = [
    helm_release.nginx_ingress_chart,
  ]
  metadata {
    name      = "${var.cluster_name}-ingress"
    namespace = "default"
    annotations = {
      "kubernetes.io/ingress.class"          = "nginx"
      "ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"       = "letsencrypt-production"
    }
  }
  spec {
    dynamic "rule" {
      for_each = toset(var.top_level_domains)
      content {
        host = rule.value
        http {
          path {
            backend {
              service_name = "${replace(rule.value, ".", "-")}-service"
              service_port = 80
            }
            path = "/"
          }
        }
      }
    }
    dynamic "tls" {
      for_each = toset(var.top_level_domains)
      content {
        secret_name = "${replace(tls.value, ".", "-")}-tls"
        hosts       = [tls.value]
      }
    }
  }
}
