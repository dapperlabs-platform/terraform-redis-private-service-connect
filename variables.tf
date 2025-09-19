variable "subscription_id" {
  description = "Redis Cloud subscription ID"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP Project ID where the PSC resources will be created"
  type        = string
}

variable "gcp_vpc_name" {
  description = "Name of the GCP VPC where the PSC endpoint will be created"
  type        = string
}

variable "gcp_vpc_subnet_name" {
  description = "Name of the GCP VPC subnet for the PSC endpoint"
  type        = string
}

variable "region" {
  description = "GCP Region for the PSC resources"
  type        = string
}

variable "endpoint_connection_name" {
  description = "Name for the PSC endpoint connection"
  type        = string
}

variable "redis_service_id" {
  description = "Redis Cloud service ID for the PSC connection"
  type        = string
}

variable "static_ip_name" {
  description = "Name for the static IP address"
  type        = string
}

variable "static_ip_address" {
  description = "The static IP address to reserve for the PSC endpoint"
  type        = string
}

variable "forwarding_rule_name" {
  description = "Name for the forwarding rule"
  type        = string
}

variable "dns_response_policy_name" {
  description = "Name of the DNS response policy to use"
  type        = string
}

variable "dns_rule_suffix" {
  description = "Suffix to append to the forwarding rule name for the DNS rule"
  type        = string
  default     = "-rule"
}

variable "dns_ttl" {
  description = "TTL for the DNS record"
  type        = number
  default     = 300
}
