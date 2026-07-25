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