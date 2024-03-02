variable "project_prefix" {
    type = string
    default = "nginx2"
    description = "The string to use when naming resources. Also assigned as a tag called 'project' to relevant AWS resources. Can cause issues if too long, so keep it short when possible."
}

variable "aws_region" {
    type = string
    default = "us-west-2"
    description = "AWS region to deploy to. Defaults to us-west-2 because why not lel."
}


########################
# NETWORKING VARIABLES #
########################

# Whether or not to create a dedicated vpc for this project. You'll have to supply a functional VPC ID below if this is set to false
variable "create_vpc" {
    type = bool
    default = true
    description = "Whether or not to create a VPC specifically for this project."
}

variable "vpc_id" {
    type = string
    default = null
    description = "If create_vpc is set to false, set this value to the ID of an already available VPC in your AWS account."
}

# vars related to vpc creation -- ignored if create_vpc is false
variable "vpc_cidr" {
    type = string
    default = "10.122"
    description = "IPv4 /16 CIDR block to use for the VPC's internal networking (NOT public). Not used if VPC is not created."
}

variable "allowed_ssh_ip" {
    type = string
    default = "0.0.0.0/0"
    description = "The allowed public IPv4 address range for SSH connections. Leave as-is for no IP restrictions, use appropriate /32 mask if specifying the IPv4 address of your own individual machine."
}

variable "create_private_subnets" {
    type = bool
    default = false
    description = "Whether or not to create private subnets in the created VPC. Useful for deploying other appliances that you don't want publicly accessible, or other more advanced use cases. Will also create NAT gateways for each subnet."
}

##########################
# EC2 INSTANCE VARIABLES #
##########################

variable "ami_id" {
    type = string
    default = "ami-null"
    description = "If you want to use a custom AMI besides the AWS-provided Debian 11, provide the AMI ID here. Leave as ami-null for default "
}

variable "public_ssh_key" {
    type = string
    description = "Required value. The PUBLIC key of your SSH key pair. Used for SSHing into the instance after it comes online."
}

variable "instance_type" {
    type = string
    description = "EC2 instance class to use for the evilnginx2 instance."
    default = "t3.small"
}

variable "kms_key_identifier" {
    description = "The valid identifier (ARN, alias, or ID) of the KMS key that should be used to encrypt the EBS volume associated with the Tor server. Defaults to alias/aws/ebs"
    type = string
    default = "alias/aws/ebs"
}