variable "vpc_cidr_block" {
  description = "value of vpc_cidr_block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "value of public_subnet_cidr_blocks"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}
variable "private_subnet_cidr_blocks" {
  description = "value of private_subnet_cidr_blocks"
  type        = list(string)
  default = [
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}
variable "db_subnet_cidr_blocks" {
  description = "value of db_subnet_cidr_blocks"
  type        = list(string)
  default = [
    "10.0.20.0/24",
    "10.0.21.0/24",
    "10.0.22.0/24"
  ]
}

variable "aws_availability_zones" {
  description = "value of aws_availability_zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}
