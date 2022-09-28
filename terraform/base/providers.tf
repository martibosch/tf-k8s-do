terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16.0"
    }
  }
}

provider "digitalocean" {
  # tokens are set in terraform cloud by setting the DIGITALOCEAN_TOKEN environment variable there
  token = var.do_token
}
