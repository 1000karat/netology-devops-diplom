variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "service_account_key_file" {
  description = "Path to Yandex Cloud service account authorized key"
  type        = string
  default     = "../authorized_key.json"
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "image_id" {
  description = "Yandex Cloud image ID for VM"
  type        = string
  default     = "fd82r0qtv0d5ic1o3b67"
}

variable "ssh_user" {
  description = "SSH user"
  type        = string
  default     = "ubuntu"
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "netology-vpc"
}

variable "subnet_name" {
  description = "VPC subnet name"
  type        = string
  default     = "netology-subnet"
}

variable "subnet_v4_cidr_blocks" {
  description = "Subnet CIDR blocks"
  type        = list(string)
  default     = ["10.10.0.0/24"]
}

variable "vm_name" {
  description = "Virtual machine name"
  type        = string
  default     = "docker-srv"
}

variable "platform_id" {
  type    = string
  default = "standard-v3"
}

variable "vm_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "RAM in GB"
  type        = number
  default     = 8
}

variable "vm_core_fraction" {
  description = "Guaranteed CPU percentage"
  type        = number
  default     = 50
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "scheduling_policy" {
  description = "variable scheduling_policy"
  type        = bool
  default     = true
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
