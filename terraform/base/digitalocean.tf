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
