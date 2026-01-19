# CLAUDE.md

Reusable Terraform module for Private Service Connect (PSC) between GCP VPCs and Redis Cloud. Creates PSC endpoints, static IPs, forwarding rules, and DNS response policy rules.

## Structure

```
main.tf           # PSC endpoint, forwarding rule, static IP, DNS rule
variables.tf      # Input variables
outputs.tf        # Module outputs (endpoint IDs, IPs, hostnames)
versions.tf       # Provider version constraints
```

## Notes

- Terraform >= 0.13, providers: rediscloud (= 2.3.1), google (>= 4.0)
- Module only - reference via `github.com/dapperlabs-platform/terraform-redis-private-service-connect?ref=<version>`
- Prerequisites: DNS response policy must exist, static IP within subnet CIDR
