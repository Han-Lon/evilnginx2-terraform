variable "project_prefix" {
    type = string
    default = "evilnginx2"
    description = "The string to use when naming resources. Can cause issues if too long, so keep it short when possible."
}

############################
# VULTR INSTANCE VARIABLES #
############################
variable "vultr_os_name" {
  description = "The name of the specific OS to use on Vultr. Defaults to Debian 11"
  type = string
  default = "Debian 11 x64 (bullseye)"
}

variable "vultr_plan_name" {
  description = "The name of the specific plan type to use for the instance. Defaults to 'vc2-1c-1gb', the smallest."
  type = string
  default = "vc2-1c-1gb"
}

variable "vultr_region" {
  description = "Region within Vultr to install the Tor server to. Defaults to 'ewr' (New Jersey)"
  type = string
  default = "ewr"
}

variable "public_ssh_key" {
    type = string
    description = "Required value. The PUBLIC key of your SSH key pair. Used for SSHing into the instance after it comes online."
}

variable "backups_enabled" {
  type = bool
  default = false
  description = "Whether or not you want backups enabled for the instance. Incurs extra cost. Defaults to false."
}

variable "instance_activation_email" {
  type = bool
  default = false
  description = "Whether or not Vultr should send an activation email to the account email address when the instance is ready. Defaults to false."
}

variable "instance_ddos_protection" {
  type = bool
  default = false
  description = "Whether or not to enable Vultr's DDoS protection service into the instance. Incurs extra cost. Defaults to false."
}

########################
# NETWORKING VARIABLES #
########################

variable "allowed_ssh_ip" {
    type = string
    default = "0.0.0.0"
    description = "The allowed public IPv4 address range for SSH connections. Leave as-is for no IP restrictions."
}

variable "allowed_ssh_mask" {
  type = string
  default = "0"
  description = "If allowed_ssh_ip is not 0.0.0.0, this must be set to appropriate subnet mask. Use '32' if locked down to single IP address."
}
