### Source iso variables
variable "iso_url" {
  type    = string
  default = "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-13.1.0-amd64-netinst.iso"
  description = "URL to ISO image."
}

variable "iso_checksum" {
  type    = string
  default = "sha256:658b28e209b578fe788ec5867deebae57b6aac5fce3692bbb116bab9c65568b3"
  description = "Checksum of ISO image."
}

### Resource variables
variable "cpus" {
  type    = number
  default = 1
  description = "Number of CPUs for building VM."
}

variable "memory" {
  type    = number
  default = 2048
  description = "Number of RAM for building VM."
}

variable "disk_size" {
  type    = string
  default = "8G"
  description = "Disk size for building VM."
}

### HTTP preseed variables
variable "http_directory" {
  type    = string
  default = "http"
  description = "Path to a directory to serve using an HTTP server."
}

variable "http_port_min" {
  type        = number
  default     = 9990
  description = "Minimum port to use for the HTTP server."
}

variable "http_port_max" {
  type        = number
  default     = 9999
  description = "Maximum port to use for the HTTP server."
}

variable "host_port_min" {
  type        = number
  default     = 2222
  description = "The minimum port to use for the Communicator port on VM which is forwarded to the SSH."
}

variable "host_port_max" {
  type        = number
  default     = 2229
  description = "The maximum port to use for the Communicator port on VM which is forwarded to the SSH."
}

### SSH connect variables
variable "ssh_username" {
  type    = string
  default = "debian"
  description = "Username to use to authenticate with SSH."
}

variable "ssh_password" {
  type      = string
  default   = "debian"
  sensitive = true
  description = "Password to use to authenticate with SSH."
}

variable "ssh_timeout" {
  type    = string
  default = "45m"
  description = "The time to wait for SSH to become available."
}

### Disc setting variable
variable "disk_compression" {
  type        = bool
  default     = true
  description = "Apply compression to the qcow2 disk file using qemu-img convert."
}

variable "disk_discard" {
  type        = string
  default     = "unmap"
  description = "The discard mode to use for disk."

  validation {
    condition     = can(regex("^(unmap|ignore)$", var.disk_discard))
    error_message = "The disk_discard variable must be equal one of values: unmap, ignore."
  }
}

variable "skip_compaction" {
  type        = bool
  default     = false
  description = "Skip compacts the qcow2 image using qemu-img convert"
}

variable "disk_detect_zeroes" {
  type        = string
  default     = "unmap"
  description = "The detect-zeroes mode to use for disk."

  validation {
    condition     = can(regex("^(unmap|on|off)$", var.disk_detect_zeroes))
    error_message = "The disk_detect_zeroes variable must be equal one of values: unmap, on, off."
  }
}

### GUI variables
variable "headless" {
  type    = bool
  default = false
  description = "Using GUI for building VM."
}

### Boot timeout variable
variable "boot_wait" {
  type    = string
  default = "5s"
  description = "The time to wait after booting the initial VM."
}

### Accelerator variable
variable "accelerator" {
  type        = string
  default     = "kvm"
  description = "The accelerator type for building VM."

  validation {
    condition     = can(regex("^(none|kvm|tcg|hax|hvf|whpx|xen)$", var.accelerator))
    error_message = "The accelerator variable must be equal one of values: none, kvm, tcg, hax, hvf, whpx, xen."
  }
}

### Output variables
variable "output_directory" {
  type    = string
  default = "build"
  description = "Build directory."
}

variable "os_name" {
  type    = string
  default = "debian"
  description = "Name of OS."
}

variable "format" {
  type        = string
  default     = "qcow2"
  description = "Specifies the output format of the VM image."

  validation {
    condition     = can(regex("^(qcow2|raw|vmdk|vdi|vhdx)$", var.format))
    error_message = "The format variable must be equal one of values: qcow2, raw, vmdk, vdi, vhdx."
  }
}

variable "tag" {
  type        = string
  description = "Tag name."
  default     = "12"
}

locals {
  vm_name = "${var.os_name}-${var.tag}.${var.format}"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S /sbin/shutdown -hP now"
}

### Provision dir variable
variable "provisions_dir" {
  type    = string
  default = "provisions"
  description = "The dir with provisions"
}

### Check sum type variable
variable "checksum_type" {
  type    = string
  default = "sha256"
  description = "Select checksum type"

  validation {
    condition     = can(regex("^(sha256|sha512)$", var.checksum_type))
    error_message = "The format variable must be equal one of values: sha256, sha512."
  }
}
