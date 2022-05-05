module "vpc-1" {
  source = "./vpc"

  name = "terraform-demo-vpc1"
  cidr = "10.100.0.0/16"
  create_igw = true

  public_subnets = {
    sub-1 = {
      az   = "us-east-2c"
      cidr = "10.100.10.0/24"
    }
  }
}

module "vpc-2" {
  source = "./vpc"

  name = "terraform-demo-vpc2"
  cidr = "10.200.0.0/16"
  create_igw = false

  private_subnets = {
    sub-1 = {
      az   = "us-east-2c"
      cidr = "10.200.10.0/24"
    }
  }
}

module "ec2_instance-1" {
  source     = "./ec2"
  depends_on = [module.vpc-1]

  vpc_id    = module.vpc-1.vpc_id
  subnet_id = module.vpc-1.public_subnet_ids["sub-1"]

  name          = "terraform_public_demo_a"
  instance_type = "t2.micro"
  ami           = "ami-0eea504f45ef7a8f7"
  instance_public_ip = true
}

module "ec2_instance-2" {
  source     = "./ec2"
  depends_on = [module.vpc-2]

  vpc_id    = module.vpc-2.vpc_id
  subnet_id = module.vpc-2.private_subnet_ids["sub-1"]

  name          = "terraform_private_demo_b"
  instance_type = "t2.micro"
  ami           = "ami-0eea504f45ef7a8f7"
}