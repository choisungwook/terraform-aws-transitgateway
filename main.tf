module "vpc-1" {
  source = "./vpc"

  name = "terraform-demo-vpc1"
  cidr = "10.100.0.0/16"
  create_igw = true

  public_subnets = {
    sub-1 = {
      az   = "ap-northeast-2c"
      cidr = "10.100.10.0/24"
    }
  }
}

module "vpc-2" {
  source = "./vpc"

  name = "terraform-demo-vpc2"
  cidr = "10.200.0.0/16"
  create_igw = true

  public_subnets = {
    sub-1 = {
      az   = "ap-northeast-2c"
      cidr = "10.200.10.0/24"
    }
  }
}