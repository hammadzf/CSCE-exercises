terraform {
  required_providers {
    stackit = {
      source  = "stackitcloud/stackit"
      version = "0.68.0"
    }
  }
}

provider "stackit" {
  default_region = "eu01"
  service_account_key = var.service_account_key

}

resource "stackit_ske_cluster" "scrumlr" {
  project_id             = var.project_id
  name                   = "scrumlr"
  kubernetes_version_min = "1.34.1"
  node_pools = [
    {
      name               = "scrumlrpool"
      machine_type       = "c1.3"
      os_name            = "flatcar"
      minimum            = "3"
      maximum            = "3"
      availability_zones = ["eu01-1", "eu01-2", "eu01-3"]
      volume_type        = "storage_premium_perf2"
    }
  ]
  maintenance = {
    enable_kubernetes_version_updates    = true
    enable_machine_image_version_updates = true
    start                                = "01:00:00Z"
    end                                  = "02:00:00Z"
  }
  extensions = {
    dns = {
      enabled = true
      zones = [stackit_dns_zone.scrumlr.dns_name]
    }
  }
}

resource "stackit_dns_zone" "scrumlr" {
  project_id = var.project_id
  dns_name   = var.dns_name
  name       = "Scrumlr Zone"
}