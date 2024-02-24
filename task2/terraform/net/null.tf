resource "null_resource" "ansible_playbook" {
  depends_on = [module.ubuntu_test, module.doctorly-vpc]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      ansible-playbook -i 'ubuntu@${module.ubuntu_test.public_ip},' --private-key deployer_key.pem playbook.yaml
    EOT
  }
}

