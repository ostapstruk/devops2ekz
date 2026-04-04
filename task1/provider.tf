terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-struk-bucket--eun1-az1--x-s3" # Цей бакет треба створити в AWS вручну!
    key    = "task1/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}