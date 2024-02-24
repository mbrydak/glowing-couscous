variable "environment" {
  description = "environment name"
  type        = string
  default     = "dev"
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

variable "vpc" {
  type = object({
    vpc_cidr_block               = string
    public_subnet_cidr_blocks    = list(string)
    private_subnet_cidr_blocks   = list(string)
    db_subnet_cidr_blocks        = list(string)
    aws_availability_zones       = list(string)
    enable_nat_gateway           = optional(bool)
    single_nat_gateway           = optional(bool)
    one_nat_gateway_per_az       = optional(bool)
    enable_dns_support           = optional(bool)
    enable_dns_hostnames         = optional(bool)
    create_database_subnet_group = optional(bool)
    create_igw                   = optional(bool)
    enable_ipv6                  = optional(bool)
    tags = optional(object({
      name = string
      Tier = string
    }))
    database_subnet_tags = optional(object({
      name = string
      Tier = string
    }))
    private_subnet_tags = optional(object({
      name = string
      Tier = string
    }))
    public_subnet_tags = optional(object({
      name = string
      Tier = string
    }))
    database_subnet_group_tags = optional(object({
      name = string
      Tier = string
    }))
  })
  default = {
    vpc_cidr_block = "10.0.0.0/16"
    public_subnet_cidr_blocks = [
      "10.0.1.0/24",
      "10.0.2.0/24",
      "10.0.3.0/24"
    ]
    private_subnet_cidr_blocks = [
      "10.0.10.0/24",
      "10.0.11.0/24",
      "10.0.12.0/24"
    ]
    db_subnet_cidr_blocks = [
      "10.0.20.0/24",
      "10.0.21.0/24",
      "10.0.22.0/24"
    ]
    aws_availability_zones       = ["us-west-2a", "us-west-2b", "us-west-2c"]
    enable_nat_gateway           = true
    single_nat_gateway           = true
    one_nat_gateway_per_az       = false
    enable_dns_support           = true
    enable_dns_hostnames         = true
    create_database_subnet_group = true
    create_igw                   = true
    enable_ipv6                  = false
  }
}

variable "sg" {
  type = object({
    http_port    = number
    https_port   = number
    any_port     = number
    any_protocol = string
    tcp_protocol = string
    all_ips_v4   = list(string)
    all_ips_v6   = list(string)
  })
  default = {
    http_port    = 80
    https_port   = 443
    any_port     = 0
    any_protocol = "-1"
    tcp_protocol = "tcp"
    all_ips_v4   = ["0.0.0.0/0"]
    all_ips_v6   = ["::/0"]

  }
}

variable "bastion" {
  type = object({
    associate_public_ip_address = bool
    instance_type               = string
    ami                         = string
    subnet_id                   = string
    vpc_security_group_ids      = list(string)
    iam_instance_profile        = string
  })
  default = {
    associate_public_ip_address = false
    instance_type               = "t2.micro"
    ami                         = null
    subnet_id                   = null
    vpc_security_group_ids      = null
    iam_instance_profile        = null
  }
}

variable "ssm_role" {
  type = object({
    trusted_role_services   = list(string)
    create_role             = bool
    create_instance_profile = bool
    role_name               = string
    role_requires_mfa       = bool
    custom_role_policy_arns = list(string)
  })
  default = {
    trusted_role_services   = ["ec2.amazonaws.com", ]
    create_role             = true
    create_instance_profile = true
    role_name               = null
    role_requires_mfa       = false
    custom_role_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", ]
  }
}
