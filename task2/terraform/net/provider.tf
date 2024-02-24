provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      application = "doctorly-tf-networking"
      owner       = "max@nullops.co"
      creator     = "max@nullops.co"
      environment = terraform.workspace
      managed_by  = "terraform"
    }
  }
}
