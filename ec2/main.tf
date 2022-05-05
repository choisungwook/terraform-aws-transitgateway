resource "aws_security_group" "all" {
  name = "${var.name}-sg"

  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_iam_role" "role" {
  name = "${var.name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.name}-iam-role-profile"
  role = aws_iam_role.role.name
}

resource "aws_instance" "instance" {
  subnet_id     = var.subnet_id
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.all.id]
  iam_instance_profile = aws_iam_instance_profile.profile.name
  associate_public_ip_address = var.instance_public_ip

  tags = {
    Name = "${var.name}-instance"
  }
}