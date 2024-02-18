terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
  }

  backend "s3" {
    bucket         = "prasath-demo"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "prasath-demo"
  }
}

# Terraform Provider Block
provider "aws" {
  region = var.aws_region
}