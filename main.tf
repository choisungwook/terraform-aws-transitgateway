module "vpc" {
  source = "./vpc"

  name = "terraform-demo-vpc"
  cidr = "192.168.0.0/16"
  create_igw = true

  public_subnets = {
    sub-1 = {
      az   = "ap-northeast-2c"
      cidr = "192.168.1.0/24"
    }
  }
}