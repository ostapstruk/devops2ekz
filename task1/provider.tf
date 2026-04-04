terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-struk-bucket"
    key    = "task1/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}