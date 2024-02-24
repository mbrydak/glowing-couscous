locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}
module "doctorly-vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "5.2.0"
  name             = "doctorly-vpc-${terraform.workspace}-${random_string.random.result}"
  cidr             = local.config.vpc.vpc_cidr_block
  azs              = local.config.vpc.aws_availability_zones
  private_subnets  = local.config.vpc.private_subnet_cidr_blocks
  public_subnets   = local.config.vpc.public_subnet_cidr_blocks
  database_subnets = local.config.vpc.db_subnet_cidr_blocks

  # azs             = local.azs
  # private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  # public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  # intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  # create_egress_only_igw = true

  # public_subnet_ipv6_prefixes                    = [0, 1, 2]
  # public_subnet_assign_ipv6_address_on_creation  = true
  # private_subnet_ipv6_prefixes                   = [3, 4, 5]
  # private_subnet_assign_ipv6_address_on_creation = true
  # intra_subnet_ipv6_prefixes                     = [6, 7, 8]
  # intra_subnet_assign_ipv6_address_on_creation   = true
  enable_nat_gateway           = local.config.vpc.enable_nat_gateway
  single_nat_gateway           = local.config.vpc.single_nat_gateway
  one_nat_gateway_per_az       = local.config.vpc.one_nat_gateway_per_az
  enable_dns_support           = local.config.vpc.enable_dns_support
  enable_ipv6                  = local.config.vpc.enable_ipv6
  enable_dns_hostnames         = local.config.vpc.enable_dns_hostnames
  create_database_subnet_group = local.config.vpc.create_database_subnet_group
  create_igw                   = local.config.vpc.create_igw
  tags = {
    "name" = "doctorly-vpc-${terraform.workspace}-${random_string.random.result}"
  }
  database_subnet_tags = {
    "name" = "doctorly-dbsubnet-${terraform.workspace}-${random_string.random.result}"
    "Tier" = "db"
  }
  private_subnet_tags = {
    "name" = "doctorly-privatesubnet-${terraform.workspace}-${random_string.random.result}"
    "Tier" = "private"
  }
  public_subnet_tags = {
    "name" = "doctorly-piblicsubnet-${terraform.workspace}-${random_string.random.result}"
    "Tier" = "public"
  }
  database_subnet_group_tags = {
    "name" = "doctorly-dbsubnetgroup-${terraform.workspace}"
  }
}

module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.5.1"

  vpc_id = module.doctorly-vpc.vpc_id
  endpoints = {
    ssm = {
      service             = "ssm"
      service_type        = "Interface"
      subnet_ids          = module.doctorly-vpc.private_subnets # Replace with your private subnet IDs
      private_dns_enabled = true
      # security_group_ids  = [aws_security_group.allow_443_ssm.id] # Replace with appropriate SG
      security_group_ids  = [module.security_group_ssm_443.security_group_id] # Replace with appropriate SG
    },
    ssmmessages = {
      service             = "ssmmessages"
      service_type        = "Interface"
      subnet_ids          = module.doctorly-vpc.private_subnets # Replace with your private subnet IDs
      private_dns_enabled = true
      # security_group_ids = [aws_security_group.your_security_group.id]  # Replace with appropriate SG
      # security_group_ids = [aws_security_group.allow_443_ssm.id] # Replace with appropriate SG
      security_group_ids  = [module.security_group_ssm_443.security_group_id] # Replace with appropriate SG
    }
  }
}
