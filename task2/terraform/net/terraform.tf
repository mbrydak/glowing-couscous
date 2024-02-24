terraform {
  backend "s3" {
    bucket         = "doctorly-tfstate-bucket"
    key            = "tf-networking/terraform.tfstate"
    dynamodb_table = "terraform-state-lock"
    region         = "us-west-2"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}
