output "external_ip_address" {
  description = "External NAT IP address"
  value       = yandex_compute_instance.vm.network_interface[0].nat_ip_address
}

output "ssh_connection_command" {
  description = "Ready-to-use SSH connection command"
  value       = "ssh ${var.ssh_user}@${yandex_compute_instance.vm.network_interface[0].nat_ip_address}"
}