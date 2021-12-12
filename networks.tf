# Main VPC
resource "aws_vpc" "eprank_vpc" {
  cidr_block           = var.vpc_cider
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-VPC"
  }
}

#Gateway 1
resource "aws_internet_gateway" "eprank_gw" {
  vpc_id = aws_vpc.eprank_vpc.id
  tags = {
    Name = "${var.prefix}-GW"
  }
}

#Subnet 1
resource "aws_subnet" "eprank_subnet_1" {
  vpc_id            = aws_vpc.eprank_vpc.id
  cidr_block        = var.subnet_1_cider
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.prefix}-Subnet-1"
  }
}



#Routing table 1
resource "aws_route_table" "eprank_route_table_1" {
  vpc_id = aws_vpc.eprank_vpc.id

  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_internet_gateway.eprank_gw.id
  }
  tags = {
    Name = "${var.prefix}-RT-1"
  }
}

# RT association 1
resource "aws_route_table_association" "eprank_rt_asc_1" {
  subnet_id      = aws_subnet.eprank_subnet_1.id
  route_table_id = aws_route_table.eprank_route_table_1.id
}

# Subnet 2
resource "aws_subnet" "eprank_subnet_2" {
  vpc_id            = aws_vpc.eprank_vpc.id
  cidr_block        = var.subnet_2_cider
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.prefix}-Subnet-2"
  }
}


# Routing table 2
resource "aws_route_table" "eprank_route_table_2" {
  vpc_id = aws_vpc.eprank_vpc.id

  route {
    cidr_block = var.inet_cidr
    gateway_id = aws_internet_gateway.eprank_gw.id
  }
  tags = {
    Name = "${var.prefix}-RT-2"
  }
}

# RT association 2
resource "aws_route_table_association" "eprank_rt_asc_2" {
  subnet_id      = aws_subnet.eprank_subnet_2.id
  route_table_id = aws_route_table.eprank_route_table_2.id
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.eprank_subnet_1.id, aws_subnet.eprank_subnet_2.id]
}