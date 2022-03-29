resource "aws_vpc" "task_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Environment = "training"
    Name        = "task_vpc"
  }
}

resource "aws_internet_gateway" "task_gw" {
  vpc_id = aws_vpc.task_vpc.id
  tags = {
    Name = "task_igw"
  }
}

resource "aws_route_table" "task_rt_public" {
  vpc_id = aws_vpc.task_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.task_gw.id
  }
  tags = {
    Name = "task_public_table"
  }
}

resource "aws_route_table" "task_rt_private" {
  vpc_id = aws_vpc.task_vpc.id
  tags = {
    Name = "task_private_table"
  }
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr)
  vpc_id                  = aws_vpc.task_vpc.id
  availability_zone       = var.availability_zone[count.index]
  cidr_block              = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "task_public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.task_vpc.id
  availability_zone = var.availability_zone[count.index]
  cidr_block        = var.private_cidr[count.index]
  tags = {
    Name = "task_private_subnet_${count.index}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.task_rt_public.id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_cidr)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.task_rt_private.id
}