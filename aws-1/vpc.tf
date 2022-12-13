# Create a VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

### ************ VPC ***************
resource "aws_vpc" "vpc_main_asg" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VPC-MAIN-ASG"
  }
}

### ************ SUBNETS ***************
resource "aws_subnet" "prisub_main_asg" {
  vpc_id            = aws_vpc.vpc_main_asg.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "PRISUB-MAIN-ASG"
  }
}

resource "aws_subnet" "pubsub1_main_asg" {
  vpc_id            = aws_vpc.vpc_main_asg.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PUBSUB1-MAIN-ASG"
  }
}

resource "aws_subnet" "pubsub2_main_asg" {
  vpc_id            = aws_vpc.vpc_main_asg.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PUBSUB2-MAIN-ASG"
  }
}

### ************ Internet gateway ***************
resource "aws_internet_gateway" "igw_main_asg" {
  vpc_id = aws_vpc.vpc_main_asg.id

  tags = {
    Name = "IGW-MAIN-ASG"
  }
}
### ************ NAT gateway ***************
resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_main_asg" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.prisub_main_asg.id

  tags = {
    Name = "NAT-MAIN-ASG"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_main_asg]
}



### ************ ROUTE TABLE RT-MAIN-ASG ***************

resource "aws_route_table" "rt_main_asg" {
  vpc_id = aws_vpc.vpc_main_asg.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_main_asg.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   egress_only_gateway_id = aws_egress_only_internet_gateway.igw_main_asg.id
  # }

  tags = {
    Name = "RT-MAIN-ASG"
  }
}

resource "aws_route_table_association" "pubsub1_main_asg" {
  subnet_id      = aws_subnet.pubsub1_main_asg.id
  route_table_id = aws_route_table.rt_main_asg.id
}
resource "aws_route_table_association" "pubsub2_main_asg" {
  subnet_id      = aws_subnet.pubsub2_main_asg.id
  route_table_id = aws_route_table.rt_main_asg.id
}

resource "aws_security_group" "sg_pub_main_asg" {
  name        = "sg_pub_main_asg"
  description = "security for public subnet"
  vpc_id      = aws_vpc.vpc_main_asg.id

  ingress {
    description = "security for public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-PUB-MAIN-ASG"
  }
}

resource "aws_security_group" "sg_pri_main_asg" {
  name        = "sg_pri_main_asg"
  description = "security for private subnet"
  vpc_id      = aws_vpc.vpc_main_asg.id

  ingress {
    description     = "security for private subnet"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_pub_main_asg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SG-PRI-MAIN-ASG"
  }
}
