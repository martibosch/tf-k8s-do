terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.28"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.13.1"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = "~> 1.14.0"
    # }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }
  }
}

provider "digitalocean" {
  # tokens are set in terraform cloud by setting the DIGITALOCEAN_TOKEN environment variable there
  token = var.do_token
}

provider "github" {
  # tokens are set in terraform cloud by setting the GITHUB_TOKEN environment variable there
  token = var.gh_token
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.cluster.endpoint
  token = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
  )
}

# provider "kubectl" {
#   host  = digitalocean_kubernetes_cluster.cluster.endpoint
#   token = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
#   cluster_ca_certificate = base64decode(
#     digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
#   )
#   load_config_file = false
# }

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.cluster.endpoint
    token = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate
    )
  }
}
