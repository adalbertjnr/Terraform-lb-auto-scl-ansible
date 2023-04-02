locals {
  access_from = ["0.0.0.0/0"]
}

locals {
  security_groups = {
    prod = {
      name = "prod_sg"
      description = "allow traffic to prod"
      ingress = {
        ssh =  {
          from_port = 22
          to_port = 22
          protocol = "tcp"
          cidr_blocks = local.access_from
        }
        http = {
          from_port = 80
          to_port = 80
          protocol = "tcp"
          cidr_blocks = local.access_from
        }
        https = {
          from_port = 443
          to_port = 443
          protocol = "tcp"
          cidr_blocks = local.access_from
        }
        locust = {
          from_port = 8089
          to_port = 8089
          protocol = "tcp"
          cidr_blocks = local.access_from
        }    
        app = {
          from_port = 8000
          to_port = 8000
          protocol = "tcp"
          cidr_blocks = local.access_from
        }                
      }
    }
  }
}