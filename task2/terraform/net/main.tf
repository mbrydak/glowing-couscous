locals {
  environment = terraform.workspace
  config      = module.config.data
}

module "config" {
  source = "./modules/config"
}
