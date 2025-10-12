variable "service_account_key" {
  description = "Service account key for the STACKIT Terraform Provider"
  type        = string
}

variable "project_id" {
  description = "The STACKIT project ID"
  type        = string
}

variable "dns_name" {
  description = "DNS name for generated Zone"
  type        = string
}
