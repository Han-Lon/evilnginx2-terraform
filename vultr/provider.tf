terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "~>2.19.0"
    }
  }
}

provider "vultr" {
  rate_limit = 700
  retry_limit = 3
}