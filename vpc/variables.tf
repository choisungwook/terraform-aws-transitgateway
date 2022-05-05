variable name {
  type        = string
  default     = ""
  description = "vpc 이름"
}

variable cidr {
  type        = string
  default     = ""
  description = "cidr"
}

variable public_subnets {
  type        = map
  default     = {}
  description = "public_subnet"
}

variable private_subnets {
  type        = map
  default     = {}
  description = "private_subnet"
}

variable create_igw  {
  type        = bool
  default     = false
  description = "internet gateway생성 여부"
}
