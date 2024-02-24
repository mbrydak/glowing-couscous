output "data" {
  value = {
    vpc         = var.vpc
    sg          = var.sg
    bastion     = var.bastion
    ssm_role    = var.ssm_role
    environment = var.environment
    regions = [
      "us-west-2",
    ]
  }
}
