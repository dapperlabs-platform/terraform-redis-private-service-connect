terraform {
  required_providers {
    rediscloud = {
      source  = "RedisLabs/rediscloud"
      version = "= 2.3.1"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

locals {
  cloud_provider = "GCP"
}
