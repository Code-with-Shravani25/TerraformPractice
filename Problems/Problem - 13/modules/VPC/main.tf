# VPC creation

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
}

# IGW creation and attachment
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Public Subnet Creation

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.az
}

# Private Subnet Creation

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = false
}

# Public RT creation

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id
}

# Adding Routes to Route table

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# Attaching Public RT to Public Subnet

resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Private RT

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myvpc.id
}

# Private RT Association

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
