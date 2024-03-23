data "alicloud_images" "debian11-image" {
  name_regex = "^debian_12_5_x64_*"
  most_recent = true
  owners = "system" # Alicloud-provided
}

resource "alicloud_ecs_key_pair" "name" {
  
}

# Evilnginx2 ECS instance
resource "alicloud_instance" "evilnginx2-instance" {
  instance_type = var.instance_type
  image_id = var.image_id == "image-null" ? data.alicloud_images.debian12-image.images[0].id : var.image_id
  instance_name = "${var.project_prefix}-instance"
  instance_charge_type = "PostPaid"  # Pay-as-you-go
  
  internet_charge_type = "PayByTraffic"
  internet_max_bandwidth_out = 10  # 10 Mbps -- setting this above 0 automatically assigns public IP

  system_disk_category = "cloud_efficiency"
  vswitch_id = alicloud_vswitch.nginx2-vswitch.id
}