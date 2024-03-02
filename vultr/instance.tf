##################
# VULTR INSTANCE #
##################

data "vultr_os" "debian-os" {
  filter {
    name   = "name"
    values = [var.vultr_os_name]
  }
}

data "vultr_plan" "vultr-plan" {
  filter {
    name   = "id"
    values = [var.vultr_plan_name]
  }
}

resource "vultr_startup_script" "install-evilnginx2" {
  name   = "install-${var.project_prefix}-script"
  script = base64encode(file("./install-evilnginx2.sh")
  )
}

resource "vultr_ssh_key" "ssh-key" {
  name    = "${var.project_prefix}-ssh-key"
  ssh_key = var.public_ssh_key
}

resource "vultr_instance" "evilnginx2-server" {
  plan = data.vultr_plan.vultr-plan.id
  region = var.vultr_region
  os_id = data.vultr_os.debian-os.id
  label = "${var.project_prefix}-instance"
  tags = [var.project_prefix]
  hostname = "${var.project_prefix}-instance"
  enable_ipv6 = false
  backups = var.backups_enabled ? "enabled" : "disabled"
  activation_email = var.instance_activation_email
  ddos_protection = var.instance_ddos_protection
  script_id = vultr_startup_script.install-evilnginx2.id
  ssh_key_ids = [vultr_ssh_key.ssh-key.id]
  firewall_group_id = vultr_firewall_group.evilnginx2-firewall.id
}

output "instance-public-ip" {
    value = vultr_instance.evilnginx2-server.main_ip
}