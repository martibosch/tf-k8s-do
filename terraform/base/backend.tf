terraform {
  cloud {
    organization = "exaf-epfl"
    workspaces {
      name = "tf-k8s-do-base"
    }
  }
}
