module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "VPC-MAIN-ASG"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.3.0/24"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]

  enable_nat_gateway            = true
  enable_vpn_gateway            = false
  create_igw                    = true
  manage_default_security_group = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


module "ec2_instance_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "PUB-LINUX"

  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.aws_training.key_name
  monitoring                  = true
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.vpc.default_security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance_private" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "PRI-LINUX"

  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.aws_training.key_name
  monitoring                  = true
  associate_public_ip_address = false
  vpc_security_group_ids      = [module.vpc.default_security_group_id]
  subnet_id                   = module.vpc.private_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
