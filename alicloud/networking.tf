data "alicloud_zones" "default" {
  available_disk_category = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "nginx2-vpc" {
  vpc_name = var.project_prefix
  cidr_block = var.vpc_cidr_block
}

resource "alicloud_vswitch" "nginx2-vswitch" {
  vpc_id = alicloud_vpc.nginx2-vpc.id
  cidr_block = var.vpc_cidr_block # By default, vswitch just uses the whole IP space of the VPC
  zone_id = var.alicloud_region
  vswitch_name = "${var.project_prefix}-vswitch"
}