module "vpc" {
  source = "./vpc"

  name = "terraform-demo-vpc"
  cidr = "10.100.0.0/16"
  create_igw = true

  public_subnets = {
    sub-1 = {
      az   = "ap-northeast-2c"
      cidr = "10.100.10.0/24"
    }
  }
}