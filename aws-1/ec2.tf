

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
