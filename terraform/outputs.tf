output "ansible_inventory" {
  description = "Path to generated Ansible inventory"
  value       = local_file.ansible_inventory.filename
}

output "ssh_connection_command" {
  description = "Ready-to-use SSH connection command"
  value       = "ssh ${var.ssh_user}@${yandex_compute_instance.vm.network_interface[0].nat_ip_address}"
}