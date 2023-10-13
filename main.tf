terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "slow_query_performance_in_postgresql" {
  source    = "./modules/slow_query_performance_in_postgresql"

  providers = {
    shoreline = shoreline
  }
}