terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "xcelvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id            = aws_vpc.xcelvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
 
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id            = aws_vpc.xcelvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"
 
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.xcelvpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.xcelvpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "my_security_group" {
  name_prefix = "my_sg_"
  vpc_id      = aws_vpc.xcelvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.xcelvpc.id

  ingress {
    description      = "allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}