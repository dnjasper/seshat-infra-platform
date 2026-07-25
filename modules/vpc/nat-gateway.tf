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