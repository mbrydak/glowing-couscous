output "vpc_id" {
  value = module.doctorly-vpc.vpc_id
}

output "instance_public_ip" {
  value = module.ubuntu_test.public_ip
}

