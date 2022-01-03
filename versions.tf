terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.41, < 4.0.0"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}