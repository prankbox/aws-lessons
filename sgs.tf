resource "aws_security_group" "eprank_ec2_sg" {
  name   = "eprank-sg-EC2"
  vpc_id = aws_vpc.eprank_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.myip.address}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.inet_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.inet_cidr]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = [var.inet_cidr]
    prefix_list_ids = []
  }
  tags = {
    "Name" = "${var.prefix}-SG"
  }
}

resource "aws_security_group" "eprank_rds_sg" {
  name        = "eprank-sg-RDS"
  description = "Allow MySQL inbound traffic"
  vpc_id      = aws_vpc.eprank_vpc.id

  ingress {
    description     = "RDS from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.eprank_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.inet_cidr]
  }
  depends_on = [aws_security_group.eprank_ec2_sg]
}

resource "aws_security_group" "eprank_efs_sg" {
  name        = "eprank-sg-EFS"
  description = "Allow NFS inbound traffic"
  vpc_id      = aws_vpc.eprank_vpc.id

  ingress {
    description     = "NFS from EC2"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.eprank_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_security_group.eprank_ec2_sg]
}

resource "aws_security_group" "eprank_elb_sg" {
  name        = "eprank-sg-ELB"
  description = "Allow traffic for ELB"
  vpc_id      = aws_vpc.eprank_vpc.id

  ingress {
    description = "Allow all inbound traffic on the 80 port"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.eprank_ec2_sg.id]
  }
  depends_on = [aws_security_group.eprank_ec2_sg]
}