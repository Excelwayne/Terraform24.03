# Create a VPC
resource "aws_vpc" "Xcelvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Xcelvpc-vpc"
  }
}

# Create two subnets in separate availability zones
resource "aws_subnet" "public_az1" {
  vpc_id            = aws_vpc.Xcelvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Xcelvpc-public-subnet-az1"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id            = aws_vpc.Xcelvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "Xcelvpc-public-subnet-az2"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.Xcelvpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Xcelvpc-private-subnet-az1"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "Xcelvpc" {
  vpc_id = aws_vpc.Xcelvpc.id

  tags = {
    Name = "Xcelvpc-internet-gateway"
  }
}

# Create a route table and associate it with the VPC
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.Xcelvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Xcelvpc.id
  }

  tags = {
    Name = "Xcelvpc-public-route-table"
  }
}

# Associate the public subnets with the route table
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# Create a route table for the private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.Xcelvpc.id

  tags = {
    Name = "Xcelvpc-private-route-table"
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}
