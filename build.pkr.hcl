source "qemu" "debian" {
  # Accelerator
  accelerator = "kvm"

  # Source image
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # Output image
  output_directory = var.output_directory
  vm_name          = "${var.vm_name}.${var.format}"

  # Resources
  memory    = var.ram_size
  cpus      = var.cpus
  disk_size = var.disk_size

  # VM settings
  disk_interface = var.disk_interface
  net_device     = var.net_device
  format         = var.format

  # Graphic settings
  headless = var.headless

  # Autoinstall
  boot_wait      = var.boot_wait
  http_directory = var.http_directory
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"
  ]

  # SSH
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  ssh_wait_timeout = var.ssh_timeout

  # Shutdown
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

build {
  sources = ["source.qemu.debian"]

  provisioner "shell" {
    execute_command = "echo 'packer' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    script          = "./scripts/provision.sh"
  }

  post-processors {
    post-processor "shell-local" {
      execute_command = ["bash", "-c", "{{.Vars}} {{.Script}}"]
      inline = [
        "sha256sum output/${var.vm_name}.${var.format} > output/${var.vm_name}.${var.format}.sha256"
      ]
    }
  }
}
