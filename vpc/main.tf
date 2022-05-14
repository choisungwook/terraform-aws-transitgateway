resource "aws_vpc" "main" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.name}-public-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = "${var.name}-private-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  count = length(var.public_subnets) > 0 && var.create_igw ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.private_subnets) > 0 && var.create_igw ? 1 : 0 

  vpc = true
  
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.name}-nat"
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.private_subnets) > 0 && var.create_igw ? 1 : 0 
  
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = [for _, v in aws_subnet.public: v.id][0]

  tags = {
    Name = "${var.name}-natgw"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? 1: 0

  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table" "private" {
  count = length(var.private_subnets) > 0 ? 1: 0

  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "${var.name}-private"
  }
}

resource "aws_route" "public_internet_gateway" {
  count = var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway" {
  count = var.create_natgw && length(var.private_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[0].id
}