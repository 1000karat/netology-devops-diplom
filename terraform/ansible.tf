resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOT
    [docker]
    ${var.vm_name} ansible_host=${yandex_compute_instance.vm.network_interface[0].nat_ip_address} ansible_user=${var.ssh_user} ansible_python_interpreter=/usr/bin/python3.10
  EOT

  depends_on = [
    yandex_compute_instance.vm
  ]
}