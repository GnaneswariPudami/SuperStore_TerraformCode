terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket         = "superstore-terraform-state-file"
    key            = "superstore_terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "superstore-terraform-locks"
    encrypt        = true
  }
}