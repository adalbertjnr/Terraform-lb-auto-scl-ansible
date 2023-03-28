module "dev" {
  source = "../../infra"
  region = "us-east-1"
  instance = "t2.micro"
  ssh_key_path = var.ssh_key_path
  ssh_name = "dev-pubkey"
  instance_name = "instance-dev"
  vpc_cidr = var.vpc_cidr
  security_groups = local.security_groups
  playbook = var.playbook
  ssh_private_key_path = var.ssh_private_key_path
  max_size = 1
  min_size = 1
  scaling_group = "dev-scaling"
  auto_scaling_ec2_name = "dev-autoscl"
  subnet_cidr = [for i in range(1,4,2) : cidrsubnet(var.vpc_cidr, 8, i)]
  sg_name = "dev"
  lb_name = "dev-lb"
}