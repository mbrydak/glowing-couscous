module "ubuntu_test" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name                        = "ubuntu-test-${random_string.random.result}"
  # associate_public_ip_address = false
  associate_public_ip_address = true
  instance_type = local.config.bastion.instance_type
  ami                         = data.aws_ami.ubuntu_latest.id
  subnet_id = module.doctorly-vpc.public_subnets[0]
  key_name = aws_key_pair.deployer.key_name
  # subnet_id              = module.doctorly-vpc.private_subnets[0]
  vpc_security_group_ids = [module.security_group_ssm_443.security_group_id, module.bastion_sg.security_group_id]
  iam_instance_profile   = module.ssm_role.iam_instance_profile_id
  tags = {
    "name" = "doctorly-${terraform.workspace}-ubuntu-test-${random_string.random.result}"
    "ansible_me" = "yes"
  }
}

module "ssm_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.2.0"

  trusted_role_services   = local.config.ssm_role.trusted_role_services
  create_role             = local.config.ssm_role.create_role
  create_instance_profile = local.config.ssm_role.create_instance_profile
  role_name               = "bastion-ssm-role-${terraform.workspace}"
  role_requires_mfa       = local.config.ssm_role.role_requires_mfa
  custom_role_policy_arns = local.config.ssm_role.custom_role_policy_arns
}
