##############
# NETWORKING #
##############
module "fresh-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  count = var.create_vpc ? 1 : 0

  name = "${var.project_prefix}-vpc"
  cidr = "${var.vpc_cidr}.0.0/16"

  azs             = ["${data.aws_region.current-region.name}a", "${data.aws_region.current-region.name}b"]
  public_subnets  = ["${var.vpc_cidr}.1.0/24", "${var.vpc_cidr}.2.0/24"]
  private_subnets = var.create_private_subnets ? ["${var.vpc_cidr}.10.0/24", "${var.vpc_cidr}.11.0/24"] : []

  enable_nat_gateway = var.create_private_subnets

  default_security_group_egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow outbound traffic"
    }
  ]
}

resource "aws_security_group" "the-instance-sg" {
    name = "${var.project_prefix}-instance-sg"
    description = "For the ${var.project_prefix} EC2 instance."
    vpc_id = var.create_vpc ? module.fresh-vpc[0].vpc_id : var.vpc_id
}

resource "aws_security_group_rule" "instance-sg-outbound" {
    from_port = 0
    protocol = "-1"
    to_port = 0
    security_group_id = aws_security_group.the-instance-sg.id
    type = "egress"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance-sg-inbound-ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.the-instance-sg.id
    cidr_blocks = [var.allowed_ssh_ip]
}

resource "aws_security_group_rule" "instance-sg-inbound-https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.the-instance-sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "instance-sg-inbound-dns" {
  type = "ingress"
  from_port = 53
  to_port = 53
  protocol = "udp"
  security_group_id = aws_security_group.the-instance-sg.id
  cidr_blocks = ["0.0.0.0/0"]
}