provider "aws" {
  region = "eu-central-1"
  profile = "tfuser"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "hackathon-cloud-terraform-state"
    key = "hackathon-cloud-terraform.tfstate"
    region = "eu-central-1"
    profile = "tfuser"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.42.0"
    }
  }
}
