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