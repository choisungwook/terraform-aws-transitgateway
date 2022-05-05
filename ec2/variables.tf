variable name {
  type        = string
  default     = ""
  description = "ec2 이름"
}

variable vpc_id {
  type        = string
  default     = ""
  description = "vpc id"
}

variable instance_type {
  type        = string
  default     = "t2.micro"
  description = "instance_type"
}

variable ami {
  type        = string
  default     = ""
  description = "ami"
}

variable subnet_id {
  type        = string
  default     = ""
  description = "subnet id"
}

variable instance_public_ip {
  type        = bool
  default     = false
  description = "instance public ip설정 유무"
}
