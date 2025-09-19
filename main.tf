# Private Service Connect configuration

# Redis Cloud PSC endpoint
resource "rediscloud_private_service_connect_endpoint" "redis_psc_endpoint" {
  subscription_id                    = var.subscription_id
  gcp_project_id                     = var.gcp_project_id
  gcp_vpc_name                       = var.gcp_vpc_name
  gcp_vpc_subnet_name                = var.gcp_vpc_subnet_name
  endpoint_connection_name           = var.endpoint_connection_name
  private_service_connect_service_id = var.redis_service_id
}

# Reserve static IP for PSC endpoint
resource "google_compute_address" "redis_psc_static_ip" {
  name         = var.static_ip_name
  project      = var.gcp_project_id
  region       = var.region
  subnetwork   = "projects/${var.gcp_project_id}/regions/${var.region}/subnetworks/${var.gcp_vpc_subnet_name}"
  address_type = "INTERNAL"
  address      = var.static_ip_address
}

# Google Cloud forwarding rule
resource "google_compute_forwarding_rule" "redis_psc_forwarding_rule" {
  name                  = var.forwarding_rule_name
  project               = var.gcp_project_id
  region                = var.region
  target                = rediscloud_private_service_connect_endpoint.redis_psc_endpoint.service_attachments[0].name
  network               = "projects/${var.gcp_project_id}/global/networks/${var.gcp_vpc_name}"
  subnetwork            = "projects/${var.gcp_project_id}/regions/${var.region}/subnetworks/${var.gcp_vpc_subnet_name}"
  ip_address            = google_compute_address.redis_psc_static_ip.address
  load_balancing_scheme = ""
}

# DNS Response Policy Rule to map Redis PSC hostname to static IP
resource "google_dns_response_policy_rule" "redis_psc_dns_rule" {
  project         = var.gcp_project_id
  response_policy = var.dns_response_policy_name
  rule_name       = "${google_compute_forwarding_rule.redis_psc_forwarding_rule.name}-rule"
  dns_name        = "psc.${var.subscription_id}.gcp.cloud.rlrcp.com."

  local_data {
    local_datas {
      name    = "psc.${var.subscription_id}.gcp.cloud.rlrcp.com."
      type    = "A"
      ttl     = var.dns_ttl
      rrdatas = [google_compute_address.redis_psc_static_ip.address]
    }
  }
}

data "rediscloud_private_service_connect" "redis_psc_data" {
  subscription_id = var.subscription_id
}
