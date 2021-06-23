# Set AWS as provider
provider "aws" {
  region     = "us-east-1"
  profile    = "terraform"
}

# Provision VPC
resource "aws_vpc" "ibm" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = { 
    Name = "IBM-VPC"
  }
}

# Provision PUBLIC SUBNET
resource "aws_subnet" "ibm-pub" {
  vpc_id     = aws_vpc.ibm.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = "IBM-PUB-SN"
  }
}

# Provision PRIVATE SUBNET
resource "aws_subnet" "ibm-pvt" {
  vpc_id     = aws_vpc.ibm.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1b"

  tags = {
    Name = "IBM-PVT-SN"
  }
}

# Provision IGW
resource "aws_internet_gateway" "ibm-igw" {
  vpc_id = aws_vpc.ibm.id

  tags = {
    Name = "IBM-IGW"
  }
}

# Provision PUB RTB
resource "aws_route_table" "ibm-pub-rtb" {
  vpc_id = aws_vpc.ibm.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm-igw.id
  }
 
  tags = {
     Name = "IBM-PUB-RT"
  }
}

# Provision PVT RTB
resource "aws_route_table" "ibm-pvt-rtb" {
  vpc_id = aws_vpc.ibm.id

  tags = {
     Name = "IBM-PVT-RT"
  }
}

# Associate RTB WITH PUB SUBNETS
resource "aws_route_table_association" "ibm-pub-assc" {
  subnet_id      = aws_subnet.ibm-pub.id
  route_table_id = aws_route_table.ibm-pub-rtb.id
}

# Associate RTB WITH PVT SUBNETS
resource "aws_route_table_association" "ibm-pvt-assc" {
  subnet_id      = aws_subnet.ibm-pvt.id
  route_table_id = aws_route_table.ibm-pvt-rtb.id
}




