data "google_dns_managed_zone" "env_dns_zone" {
  name    = var.dns_zone_name
  project = var.dns_zone_project
}

# Private Service Connect configuration
resource "rediscloud_private_service_connect" "service" {
  subscription_id = var.subscription_id
}

# Create one endpoint for each region defined in the map.
resource "rediscloud_private_service_connect_endpoint" "redis_psc_endpoint" {
  for_each = var.regions

  subscription_id                    = var.subscription_id
  gcp_project_id                     = var.gcp_project_id
  gcp_vpc_name                       = var.gcp_vpc_name
  gcp_vpc_subnet_name                = each.value                                 # Use the subnet name from the map
  endpoint_connection_name           = "redis-${var.subscription_id}-${each.key}" # Unique name per region
  private_service_connect_service_id = rediscloud_private_service_connect.service.private_service_connect_service_id
}

# Create one internal IP address in each region/subnet.
# Let GCP pick IP address dynamically
resource "google_compute_address" "redis_psc_static_ip" {
  for_each = var.regions

  name         = "redis-psc-ip-${each.key}" # Unique name per region
  project      = var.gcp_project_id
  region       = each.key # Use the region from the map key
  subnetwork   = "projects/${var.gcp_project_id}/regions/${each.key}/subnetworks/${each.value}"
  address_type = "INTERNAL"
}

# Create one forwarding rule in each region to connect the IP to the endpoint.
resource "google_compute_forwarding_rule" "redis_psc_forwarding_rule" {
  for_each = var.regions

  name    = "redis-psc-fw-rule-${each.key}" # Unique name per region
  project = var.gcp_project_id
  region  = each.key # Use the region from the map key

  # Point to the correct regional service attachment
  target = rediscloud_private_service_connect_endpoint.redis_psc_endpoint[each.key].service_attachments[0].name

  network = "projects/${var.gcp_project_id}/global/networks/${var.gcp_vpc_name}"

  # Point to the correct regional static IP
  ip_address            = google_compute_address.redis_psc_static_ip[each.key].address
  load_balancing_scheme = ""
}

# It creates ONE 'A' record with a GEO routing policy that maps all regional IPs. 
# Clients in a specific region will get the IP for that region.
resource "google_dns_record_set" "redis_psc_geo_dns" {
  project = var.gcp_project_id
  name    = "${data.rediscloud_private_service_connect.redis_psc_data.connection_host_name}."
  type    = "A"
  ttl     = var.dns_ttl

  # The DNS zone to create the A record in
  managed_zone = data.google_dns_managed_zone.env_dns_zone.name

  routing_policy {
    # Create a GEO routing policy for each region to map the DNS entry to that region's
    # specific endpoint IP address
    dynamic "geo" {
      for_each = google_compute_address.redis_psc_static_ip
      content {
        location = geo.key
        rrdatas  = [geo.value.address]
      }
    }
  }
}

data "rediscloud_private_service_connect" "redis_psc_data" {
  subscription_id = var.subscription_id
}

# # Redis Cloud PSC endpoint
# resource "rediscloud_private_service_connect_endpoint" "redis_psc_endpoint" {
#   subscription_id                    = var.subscription_id
#   gcp_project_id                     = var.gcp_project_id
#   gcp_vpc_name                       = var.gcp_vpc_name
#   gcp_vpc_subnet_name                = var.gcp_vpc_subnet_name
#   endpoint_connection_name           = "redis-${var.subscription_id}"
#   private_service_connect_service_id = rediscloud_private_service_connect.service.private_service_connect_service_id
# }
#
# # Reserve static IP for PSC endpoint
# resource "google_compute_address" "redis_psc_static_ip" {
#   name         = var.static_ip_name
#   project      = var.gcp_project_id
#   region       = var.region
#   subnetwork   = "projects/${var.gcp_project_id}/regions/${var.region}/subnetworks/${var.gcp_vpc_subnet_name}"
#   address_type = "INTERNAL"
#   address      = var.static_ip_address
# }
#
# # Google Cloud forwarding rule
# resource "google_compute_forwarding_rule" "redis_psc_forwarding_rule" {
#   name    = var.forwarding_rule_name
#   project = var.gcp_project_id
#   region  = var.region
#   target  = rediscloud_private_service_connect_endpoint.redis_psc_endpoint.service_attachments[0].name
#   network = "projects/${var.gcp_project_id}/global/networks/${var.gcp_vpc_name}"
#   #subnetwork            = "projects/${var.gcp_project_id}/regions/${var.region}/subnetworks/${var.gcp_vpc_subnet_name}"
#   ip_address            = google_compute_address.redis_psc_static_ip.address
#   load_balancing_scheme = ""
# }
#
# # DNS Response Policy Rule to map Redis PSC hostname to static IP
# resource "google_dns_response_policy_rule" "redis_psc_dns_rule" {
#   project         = var.gcp_project_id
#   response_policy = var.dns_response_policy_name
#   rule_name       = "${google_compute_forwarding_rule.redis_psc_forwarding_rule.name}-rule"
#   dns_name        = "${data.rediscloud_private_service_connect.redis_psc_data.connection_host_name}."
#
#   local_data {
#     local_datas {
#       name    = "${data.rediscloud_private_service_connect.redis_psc_data.connection_host_name}."
#       type    = "A"
#       ttl     = var.dns_ttl
#       rrdatas = [google_compute_address.redis_psc_static_ip.address]
#     }
#   }
# }
#
# data "rediscloud_private_service_connect" "redis_psc_data" {
#   subscription_id = var.subscription_id
# }
