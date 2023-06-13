# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-vpc"
  }
}

#=====================================================#

# Public Subnets
resource "aws_subnet" "public_sub" {
  count = var.AZs

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project}-public_sub"
  }
  map_public_ip_on_launch = true
}

#=====================================================#

# Private Subnets
resource "aws_subnet" "private_sub" {
  count = var.AZs

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, var.subnet_cidr_bits, count.index + var.AZs)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.project}-private_sub"
  }
}

#=====================================================#

# Internet Gateway
resource "aws_internet_gateway" "Internet-GW" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    "Name" = "${var.project}-igw"
  }

  depends_on = [aws_vpc.main_vpc]
}

#=====================================================#

# Route the public subnet traffic through the IGW
resource "aws_route_table" "Pub_RT" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet-GW.id
  }

  tags = {
    Name = "${var.project}-Pub_RT"
  }
}


# Route table and subnet associations
resource "aws_route_table_association" "Pub_internet_access" {
  count = var.AZs

  subnet_id      = aws_subnet.public_sub[count.index].id
  route_table_id = aws_route_table.Pub_RT.id
}

#=====================================================#

# NAT Elastic IP
resource "aws_eip" "main" {
  domain   = "vpc"
  
  tags = {
    Name = "${var.project}-NAT_GT_ip"
  }
}

#=====================================================#

# NAT Gateway
resource "aws_nat_gateway" "NAT_GT" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.public_sub[0].id

  tags = {
    Name = "${var.project}-NAT_GT"
  }
}

#=====================================================#

resource "aws_route_table" "Priv_RT" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GT.id
  }

  tags = {
    Name = "${var.project}-Priv_RT"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "Priv_internet_access" {
  count = var.AZs

  subnet_id      = aws_subnet.private_sub[count.index].id
  route_table_id = aws_route_table.Priv_RT.id
}

#=====================================================#

data "aws_availability_zones" "available" {
  state = "available"
}