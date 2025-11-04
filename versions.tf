terraform {
  required_providers {
    rediscloud = {
      source  = "RedisLabs/rediscloud"
      version = "~> 2.0"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0"
    }
  }
}
