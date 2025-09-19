output "psc_endpoint_id" {
  description = "ID of the Redis Cloud PSC endpoint"
  value       = rediscloud_private_service_connect_endpoint.redis_psc_endpoint.id
}

output "psc_endpoint_service_attachments" {
  description = "Service attachments for the PSC endpoint"
  value       = rediscloud_private_service_connect_endpoint.redis_psc_endpoint.service_attachments
}

output "static_ip_address" {
  description = "The static IP address reserved for the PSC endpoint"
  value       = google_compute_address.redis_psc_static_ip.address
}

output "static_ip_id" {
  description = "ID of the static IP address resource"
  value       = google_compute_address.redis_psc_static_ip.id
}

output "forwarding_rule_id" {
  description = "ID of the forwarding rule"
  value       = google_compute_forwarding_rule.redis_psc_forwarding_rule.id
}

output "forwarding_rule_name" {
  description = "Name of the forwarding rule"
  value       = google_compute_forwarding_rule.redis_psc_forwarding_rule.name
}

output "dns_rule_id" {
  description = "ID of the DNS response policy rule"
  value       = google_dns_response_policy_rule.redis_psc_dns_rule.id
}

output "redis_psc_connection_host_name" {
  description = "Redis Cloud PSC connection hostname"
  value       = data.rediscloud_private_service_connect.redis_psc_data.connection_host_name
}

