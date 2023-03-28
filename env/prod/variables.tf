variable "ssh_key_path" {
  type = string
  default = "~/.ssh/ansible.pub"
}

variable "vpc_cidr" {}

variable "playbook" {
  type = string
  default = "playbook-prod"
} 

variable "ssh_private_key_path" {}
