# data "aws_availability_zones" "available" {}

# resource "random_shuffle" "shuffle_az" {
#   input        = ["us-east-1a", "us-east-1b"]
#   result_count = 2
# }

resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "r" {
  route_table_id = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "rt_asc" {
  count = 2
  subnet_id = aws_subnet.the_real_subnet.*.id[count.index]
  route_table_id = aws_route_table.rt.id
}

resource "aws_subnet" "the_real_subnet" {
  count             = 2
  vpc_id            = aws_vpc.example.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "The-Subnet-${count.index + 1}"
  }
}

# resource "aws_subnet" "the_real_subnet2" {
#   vpc_id = aws_vpc.example.id
#   cidr_block = var.subnet_cidr
#   availability_zone = "${var.region}b"
#   tags = {
#     "Name" = "The-Subnet2"
#   }
# }

resource "aws_security_group" "security_group" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.example.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "The-real-security-group"
  }
}

