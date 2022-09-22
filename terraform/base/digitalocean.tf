resource "digitalocean_project" "project" {
  name        = var.project_slug
  description = var.project_description

  resources = [
    digitalocean_kubernetes_cluster.cluster.urn
  ]
}

resource "digitalocean_vpc" "vpc" {
  name   = "${var.project_slug}-vpc"
  region = var.do_region
}

data "digitalocean_kubernetes_versions" "prefix" {
  version_prefix = "${var.k8s_minor_version}."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name         = "${var.project_slug}-cluster"
  region       = var.do_region
  auto_upgrade = true
  version      = data.digitalocean_kubernetes_versions.prefix.latest_version

  vpc_uuid = digitalocean_vpc.vpc.id

  maintenance_policy {
    start_time = var.maintenance_start_time
    day        = var.maintenance_day
  }

  node_pool {
    name       = "${var.project_slug}-cluster-pool"
    size       = var.default_node_size
    auto_scale = true
    min_nodes  = var.min_nodes
    max_nodes  = var.max_nodes
  }
}

resource "digitalocean_loadbalancer" "ingress_load_balancer" {
  name      = "${var.project_slug}-lb"
  region    = var.do_region
  size      = var.load_balancer_size
  algorithm = var.load_balancer_algorithm

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

  }

  lifecycle {
    ignore_changes = [
      forwarding_rule,
    ]
  }

}

resource "digitalocean_domain" "top_level_domains" {
  for_each = toset(jsondecode(var.top_level_domains))
  name     = each.value
}

resource "digitalocean_record" "a_records" {
  for_each = toset(jsondecode(var.top_level_domains))
  domain   = each.value
  type     = "A"
  ttl      = 60
  name     = "@"
  value    = digitalocean_loadbalancer.ingress_load_balancer.ip
  depends_on = [
    digitalocean_domain.top_level_domains,
    kubernetes_ingress.cluster_ingress
  ]
}

resource "digitalocean_record" "cname_redirects" {
  for_each = toset(jsondecode(var.top_level_domains))
  domain   = each.value
  type     = "CNAME"
  ttl      = 60
  name     = "www"
  value    = "@"
  depends_on = [
    digitalocean_domain.top_level_domains,
  ]
}
