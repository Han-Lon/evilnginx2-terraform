################
# EC2 INSTANCE #
################

# Pull the most recent Debian 11 AMI if none supplied by the user
data "aws_ami" "debian-official" {
  count       = var.ami_id == "ami-null" ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-11-amd64-*"]
  }

  owners = ["amazon"]
}

data "aws_kms_key" "volume-encryption-key" {
    key_id = var.kms_key_identifier
}

resource "aws_key_pair" "ssh-key" {
    public_key = var.public_ssh_key
    key_name = "${var.project_prefix}-ssh-key"
}

data "template_cloudinit_config" "userdata" {
    gzip = true
    base64_encode = true

    part {
        filename = "install-evilnginx2.sh"
        content_type = "text/x-shellscript"
        content = file("./install-evilnginx2.sh")
    }
}

resource "aws_instance" "the-instance" {
    ami = var.ami_id == "ami-null" ? data.aws_ami.debian-official[0].image_id : var.ami_id
    instance_type = var.instance_type

    subnet_id = module.fresh-vpc[0].public_subnets[0]
    associate_public_ip_address = true

    vpc_security_group_ids = [aws_security_group.the-instance-sg.id]

    key_name = aws_key_pair.ssh-key.key_name

    user_data_base64 = data.template_cloudinit_config.userdata.rendered

    root_block_device {
      encrypted = true
      kms_key_id = data.aws_kms_key.volume-encryption-key.arn
    }

    tags = {
      Name = "${var.project_prefix}-instance"
    }
}

output "instance-public-ip" {
    value = aws_instance.the-instance.public_ip
}