variable "regions" {
  description = "A map where keys are GCP regions and values are the VPC subnet names in that region."
  type        = map(string)
}

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

# variable "gcp_vpc_subnet_name" {
#   description = "Name of the GCP VPC subnet for the PSC endpoint"
#   type        = string
# }

# variable "region" {
#   description = "GCP Region for the PSC resources"
#   type        = string
# }

variable "endpoint_connection_name" {
  description = "Name for the PSC endpoint connection"
  type        = string
}

variable "redis_service_id" {
  description = "Redis Cloud service ID for the PSC connection"
  type        = string
}

# variable "static_ip_name" {
#   description = "Name for the static IP address"
#   type        = string
# }

# variable "static_ip_address" {
#   description = "The static IP address to reserve for the PSC endpoint"
#   type        = string
# }

# variable "forwarding_rule_name" {
#   description = "Name for the forwarding rule"
#   type        = string
# }

# variable "dns_response_policy_name" {
#   description = "Name of the DNS response policy to use"
#   type        = string
# }

variable "dns_ttl" {
  description = "TTL for the DNS record"
  type        = number
  default     = 300
}

##########################################################################
# DNS Variables
##########################################################################
variable "dns_zone_name" {
  description = "The name of the Cloud DNS private managed zone to create the A record in."
  type        = string
  default     = "dapper-labs-network-production-internal-dns-zone"
}

variable "dns_zone_project" {
  description = "The project ID of the Cloud DNS private managed zone to create the A record in."
  type        = string
  default     = "dl-network-production"
}

