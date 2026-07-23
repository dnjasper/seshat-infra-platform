resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# SUBNETS

#Public Subnets

data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-az1"

    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/seshat-cluster" = "shared"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet-az2"
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/seshat-cluster" = "shared"
  }
}



# Private Subnets

resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-az1"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/seshat-cluster" = "shared"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet-az2"
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/seshat-cluster" = "shared"
  }
}


# IGW

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

tags = {
    Name = "${var.project_name}-${var.environment}-igw"
 }
}


# PUBLIC Route Table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-route-table"
  }
}

# Association of public subnet AZ1 with the public route table
resource "aws_route_table_association" "public_subnet_az1_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_association" {
  subnet_id = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# PRIVATE Route Table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-private-route-table"
  }
}

# PRIVATE Route Association

resource "aws_route_table_association" "private_subnet_az1_association" {
  subnet_id = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_az2_association" {
  subnet_id = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_route_table.id
}

# EIP & NAT Gateway

resource "aws_eip" "eks-workers" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-eip"
  }
}

resource "aws_nat_gateway" "seshat" {
 depends_on = [aws_internet_gateway.internet_gateway]
 allocation_id = aws_eip.eks-workers.id
 subnet_id = aws_subnet.public_subnet_az1.id

 tags = {
   Name = "${var.project_name}-${var.environment}-nat-gateway"
 }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.seshat.id
}