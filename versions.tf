terraform {
  required_providers {
    mongodbatlas = {
      source = "hashicorp/aws"
      version = ">= 3.41"
    }
  }
  required_version = ">= 0.13"
}