# Redis Cloud Private Service Connect Module

This Terraform module creates a Redis Cloud Private Service Connect (PSC) configuration for Google Cloud Platform. It sets up the necessary resources to establish a private connection between your GCP VPC and Redis Cloud.

## Resources Created

- `rediscloud_private_service_connect_endpoint` - Redis Cloud PSC endpoint
- `google_compute_address` - Static IP address for the PSC endpoint
- `google_compute_forwarding_rule` - GCP forwarding rule for the PSC connection
- `google_dns_response_policy_rule` - DNS rule to map Redis PSC hostname to static IP

## Usage

```hcl
module "redis_psc" {
  source = "./terraform-redis-psc"

  # Redis Cloud Configuration
  subscription_id          = "1653614"
  redis_service_id        = "your-redis-service-id"
  endpoint_connection_name = "redis-1653614"

  # GCP Configuration
  gcp_project_id         = "your-project-id"
  gcp_vpc_name          = "your-vpc-name"
  gcp_vpc_subnet_name   = "your-subnet-name"
  region                = "us-west1"

  # Static IP Configuration
  static_ip_name    = "redis-1653614-psc-static-ip"
  static_ip_address = "192.168.4.25"

  # Forwarding Rule Configuration
  forwarding_rule_name = "redis-1653614"

  # DNS Configuration
  dns_response_policy_name = "redis-your-vpc-name"
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| subscription_id | Redis Cloud subscription ID | `string` | n/a | yes |
| gcp_project_id | GCP Project ID where the PSC resources will be created | `string` | n/a | yes |
| gcp_vpc_name | Name of the GCP VPC where the PSC endpoint will be created | `string` | n/a | yes |
| gcp_vpc_subnet_name | Name of the GCP VPC subnet for the PSC endpoint | `string` | n/a | yes |
| region | GCP Region for the PSC resources | `string` | n/a | yes |
| endpoint_connection_name | Name for the PSC endpoint connection | `string` | n/a | yes |
| redis_service_id | Redis Cloud service ID for the PSC connection | `string` | n/a | yes |
| static_ip_name | Name for the static IP address | `string` | n/a | yes |
| static_ip_address | The static IP address to reserve for the PSC endpoint | `string` | n/a | yes |
| forwarding_rule_name | Name for the forwarding rule | `string` | n/a | yes |
| dns_response_policy_name | Name of the DNS response policy to use | `string` | n/a | yes |
| dns_rule_suffix | Suffix to append to the forwarding rule name for the DNS rule | `string` | `"-rule"` | no |
| dns_ttl | TTL for the DNS record | `number` | `300` | no |

## Outputs

| Name | Description |
|------|-------------|
| psc_endpoint_id | ID of the Redis Cloud PSC endpoint |
| psc_endpoint_service_attachments | Service attachments for the PSC endpoint |
| static_ip_address | The static IP address reserved for the PSC endpoint |
| static_ip_id | ID of the static IP address resource |
| forwarding_rule_id | ID of the forwarding rule |
| forwarding_rule_name | Name of the forwarding rule |
| dns_rule_id | ID of the DNS response policy rule |
| redis_psc_connection_host_name | Redis Cloud PSC connection hostname |
| redis_psc_connection_endpoint | Redis Cloud PSC connection endpoint |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| rediscloud | = 2.3.1 |
| google | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| rediscloud | = 2.3.1 |
| google | >= 4.0 |

## Notes

- Make sure the DNS response policy exists in your GCP project before using this module
- The static IP address must be within the subnet's CIDR range and available
- Ensure proper IAM permissions are set up for creating these resources