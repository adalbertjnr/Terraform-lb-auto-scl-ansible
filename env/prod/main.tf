module "prod" {
  source = "../../infra"
  region = "us-east-1"
  instance = "t2.micro"
  ssh_key_path = var.ssh_key_path
  ssh_name = "prod-pubkey"
  instance_name = "instance-prod"
  security_groups = local.security_groups
  vpc_cidr = var.vpc_cidr
  playbook = var.playbook
  ssh_private_key_path = var.ssh_private_key_path
  max_size = 5
  min_size = 1
  scaling_group = "prod-scaling"
  auto_scaling_ec2_name = "prod-autoscl"  
  subnet_cidr = [for i in range(1,4,2) : cidrsubnet(var.vpc_cidr, 8, i)]
  sg_name = "prod"
  lb_name = "prod-lb"
}