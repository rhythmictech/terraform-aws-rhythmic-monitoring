
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    aws = ">= 3.0"

    archive = {
      source  = "hashicorp/archive"
      version = ">= 1.3.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}
