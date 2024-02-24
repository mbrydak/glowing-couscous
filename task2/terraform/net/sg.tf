data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# SSH security group
module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "~> 5.0"

  name                = "a-snb-sg-bastion-${random_string.random.result}"
  description         = "allow ssh access to bastion host"
  vpc_id              = module.doctorly-vpc.vpc_id
  ingress_cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]

  tags = {
    "name" = "a-snb-sg-bastion-${random_string.random.result}"
  }
}

module "alb_http_80" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  name   = "alb_http_80-${terraform.workspace}"
  vpc_id              = module.doctorly-vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "webserver_http_80_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 5.0"

  name   = "webserver_http_80_security_group-${terraform.workspace}"
  vpc_id              = module.doctorly-vpc.vpc_id

  ingress_cidr_blocks = [local.config.vpc.vpc_cidr_block]

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb_http_80.security_group_id
    }
  ]
}


module "mysql_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  version = "~> 5.0"

  name                = "mysql_security_group-${terraform.workspace}"
  vpc_id              = module.doctorly-vpc.vpc_id
  ingress_cidr_blocks = [local.config.vpc.vpc_cidr_block]

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.webserver_http_80_security_group.security_group_id
    }
  ]
}

module "efs_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/nfs"
  version = "~> 5.0"

  name                = "efs_security_group-${terraform.workspace}"
  vpc_id              = module.doctorly-vpc.vpc_id
  ingress_cidr_blocks = [local.config.vpc.vpc_cidr_block]

  ingress_with_source_security_group_id = [
    {
      rule                     = "nfs-tcp"
      source_security_group_id = module.webserver_http_80_security_group.security_group_id
    }
  ]
}

module "security_group_ssm_443" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "~> 5.0"

  name   = "security_group_ssm_443-${terraform.workspace}"
  vpc_id              = module.doctorly-vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}
