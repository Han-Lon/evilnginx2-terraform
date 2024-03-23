variable "project_prefix" {
  type = string
  default = "nginx2"
  description = "The string to use when naming resources."
}

variable "alicloud_region" {
  type = string
  default = "us-west-1"
  description = "Alicloud region to deploy to. Defaults to us-west-1 (California - Silicon Valley)."
}

##########################
# ECS INSTANCE VARIABLES #
##########################

variable "instance_type" {
  description = "Alicloud instance type to use. Defaults to a small t5 burstable instance."
  type = string
  default = "ecs.t5-lc1m1.small"
}

variable "image_id" {
  description = "Image ID of the Alicloud image to use with the server. Defaults to Debian 11."
  type = string
  default = "image-null"
}

########################
# NETWORKING VARIABLES #
########################

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block to use for the ECS instance's VPC. Defaults to 10.10.0.0/16"
  type = string
  default = "10.10.0.0/16"
}