variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
}

variable "format" {
  type    = string
  default = "qcow2"
}

variable "vm_name" {
  type    = string
  default = "debian-12-packer"
}

variable "output_directory" {
  type    = string
  default = "./output"
}

variable "cpus" {
  type    = number
  default = 2
}

variable "ram_size" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = string
  default = "8G"
}

variable "disk_interface" {
  type    = string
  default = "virtio-scsi"
}

variable "net_device" {
  type    = string
  default = "virtio-net"
}

variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "http_directory" {
  type    = string
  default = "http"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "ssh_timeout" {
  type    = string
  default = "45m"
}

variable "headless" {
  type    = bool
  default = false
}
