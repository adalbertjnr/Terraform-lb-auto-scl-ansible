variable "instance" {}
variable "region" {}
variable "ssh_name" {}
variable "ssh_key_path" {}
variable "instance_name" {}
variable "security_groups" {}
variable "vpc_cidr" {}
variable "playbook" {}
variable "ssh_private_key_path" {}
variable "scaling_group" {}
variable "max_size" {}
variable "min_size" {}
variable "auto_scaling_ec2_name" {}
variable "subnet_cidr" {}
variable "sg_name" {}
variable "lb_name" {}
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "policy_name" {}