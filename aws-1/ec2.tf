data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_key_pair" "aws_training" {
  key_name   = "awstraining-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXhqpHj3IRI1AV+sGh7H4n9PMZV/+S01cJXWXMTrqNx6JN+82ssrVLYcoN5KAdG0eqdOZQmZxmdCPCW2V1zK42JKNJ4yR/R3kP8TXSthrI3zs6NNS6UwGjKULraSTk7DL9/feTQK4lYk758JV7X1zFn9xs6hTzIyYzH7ecm6pzRRPWTNgTHEyowDUoYwcRYL27K7xNaL6+yhz5AivloUBAuRRGAlRHd/jG2pqPL0y/I/4xsuNc7F6CzYkrwdygP4yok73nBA9b5TLjD4AbjyC7DTv+ORIMazWqNjAEV8Rby/uIE+yz9oId71mfng4sibRhXlblWu8WGfWf4+RqTfKd"
}

# resource "aws_network_interface" "pub_linux_interface" {
#   subnet_id = aws_subnet.pubsub1_main_asg.id
#   # private_ips = ["172.16.10.100"]
#   security_groups = [aws_security_group.sg_pub_main_asg.id]
#   tags = {
#     Name = "pub_linux_interface"
#   }
# }


resource "aws_instance" "pub_linux" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  # availability_zone           = ""
  key_name                    = aws_key_pair.aws_training.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.pubsub1_main_asg.id
  security_groups             = [aws_security_group.sg_pub_main_asg.id]
  tags = {
    Name = "PUB-LINUX"
  }
  lifecycle {
    ignore_changes = [
      credit_specification,
      security_groups
    ]
  }

}

resource "aws_instance" "pri_linux" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  # availability_zone           = ""
  key_name                    = aws_key_pair.aws_training.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.prisub_main_asg.id
  security_groups             = [aws_security_group.sg_pri_main_asg.id]
  tags = {
    Name = "PRI-LINUX"
  }
  # network_interface {
  #   network_interface_id = aws_network_interface.pub_linux_interface.id
  #   device_index         = 0
  # }
}
