##############
# NETWORKING #
##############

resource "vultr_firewall_group" "evilnginx2-firewall" {
  description = "For the ${var.project_prefix} project."
}

resource "vultr_firewall_rule" "firewall-ssh-rule" {
  firewall_group_id = vultr_firewall_group.evilnginx2-firewall.id
  protocol = "tcp"
  ip_type = "v4"
  subnet = var.allowed_ssh_ip
  subnet_size = var.allowed_ssh_mask
  port = "22"
  notes = "Allow SSH from predefined IP"
}

resource "vultr_firewall_rule" "firewall-https-rule" {
  firewall_group_id = vultr_firewall_group.evilnginx2-firewall.id
  protocol = "tcp"
  ip_type = "v4"
  subnet = "0.0.0.0"
  subnet_size = "0"
  port = "443"
  notes = "Allow HTTPS"
}

resource "vultr_firewall_rule" "firewall-http-rule" {
  firewall_group_id = vultr_firewall_group.evilnginx2-firewall.id
  protocol = "tcp"
  ip_type = "v4"
  subnet = "0.0.0.0"
  subnet_size = "0"
  port = "80"
  notes = "Allow HTTP"
}

resource "vultr_firewall_rule" "firewall-dns-rule" {
  firewall_group_id = vultr_firewall_group.evilnginx2-firewall.id
  protocol = "udp"
  ip_type = "v4"
  subnet = "0.0.0.0"
  subnet_size = "0"
  port = "53"
  notes = "Allow DNS"
}