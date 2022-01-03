provider "aws" {
    region      = var.region
    profile     = var.profile
}

variable "profile" {
    type        = string
    description = "AWS Profile to use"
    default     = null
}

variable "region" {
    type        = string
    description = "AWS Region to create the resource"
    default     = null # "us-east-1"
}