# Source
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

# Build
build {
  sources = ["source.qemu.debian"]

  # Shell provisioner
  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts = [
      "provisions/shell/clean.sh"
    ]
  }

  # Ansible provisioner
  provisioner "ansible" {
    playbook_file = "provisions/ansible/playbook.yml"
    user          = var.ssh_username
    use_proxy     = false
    extra_arguments = [
      "--extra-vars", "ansible_sudo_pass=${var.ssh_password}",
      "--extra-vars", "ansible_ssh_pass=${var.ssh_password}"
    ]
  }

  # Post-processor shell-local
  post-processor "shell-local" {
    inline = [
      "cd ${var.output_directory}",
      "sha256sum ${var.vm_name}.${var.format} > ${var.vm_name}.${var.format}.sha256",
      "ls -la ${var.vm_name}.${var.format}*"
    ]
  }

  # Post-processor compress
  post-processor "compress" {
    output = "${var.output_directory}/${var.vm_name}.${var.format}.gz"
    format = "gz"
  }
}
