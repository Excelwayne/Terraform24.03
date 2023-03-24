
# Create an EC2 instance
resource "aws_instance" "xcel1" {
  ami           = "ami-0efa651876de2a5ce"
  instance_type = "t2.micro"
  key_name      = "xcel-key"
  vpc_security_group_ids = [
    aws_security_group.my_security_group.id, aws_security_group.allow_ssh.id 
  ]
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "xcel1"
  }
} 

resource "aws_instance" "xcel2" {
  ami           = "ami-0efa651876de2a5ce"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet_1b.id
  key_name      = "xcel2pair"
  vpc_security_group_ids = [aws_security_group.my_security_group.id, aws_security_group. allow_ssh.id]

}

# resource "aws_lb" "_lb" {
#   name               = "-lb"
#   internal           = false
#   load_balancer_type = "application"

#   subnet_mapping {
#     subnet_id = aws_subnet.subnet_1a.id
#   }

#   subnet_mapping {
#     subnet_id = aws_subnet.subnet_1b.id
#   }

#   security_groups = [aws_security_group._security_group.id]

#   tags = {
#     Environment = "prod"
#   }
# }



