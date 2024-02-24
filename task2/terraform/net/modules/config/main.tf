module "_defaults" {
  source = "./_defaults"
}

module "dev" {
  source = "./dev"
}

module "staging" {
  source = "./staging"
}

module "production" {
  source = "./production"
}

locals {
  data_map = {
    dev        = module.dev.data,
    staging    = module.staging.data,
    production = module.production.data,
  }
}
