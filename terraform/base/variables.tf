variable "do_token" {}

variable "gh_token" {}

variable "project_slug" {}

variable "project_description" {}

variable "do_region" {
  default = "fra1"
}

variable "k8s_minor_version" {
  default = "1.25.2"
}

variable "maintenance_start_time" {
  default = "04:00"
}

variable "maintenance_day" {
  default = "sunday"
}

variable "default_node_size" {
  default = "s-1vcpu-2gb"
}

variable "load_balancer_size" {
  default = "lb-small"
}

variable "load_balancer_algorithm" {
  default = "round-robin"
}

variable "top_level_domains" {
  description = "Top level domains to create records and pods for"
  type        = list(string)
}

variable "letsencrypt_email" {
  type = string
}

variable "min_nodes" {
  description = "The minimum number of nodes in the default pool"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "The maximum number of nodes in the default pool"
  type        = number
  default     = 3
}
