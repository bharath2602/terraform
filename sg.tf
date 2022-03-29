resource "aws_security_group" "Ec2SG" {
  name        = "allow_elb"
  description = "allows elb to come in"
  vpc_id      = aws_vpc.task_vpc.id
  ingress {
    description      = "http from elb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    security_groups  = []
    prefix_list_ids  = []
    self             = false
  }
  ingress {
    description      = "http from elb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = [aws_security_group.ElbSG.id]
    prefix_list_ids  = []
    self             = false
  }
  ingress {
    description      = "ssh from myip"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["117.221.226.29/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_elb"
  }
}


resource "aws_security_group" "rdsSG" {
  name        = "allow_rds"
  description = "allows ec2 to rds"
  vpc_id      = aws_vpc.task_vpc.id
  ingress {
    description      = "ec2 to rds"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = []
    ipv6_cidr_blocks = []
    security_groups  = [aws_security_group.Ec2SG.id]
    prefix_list_ids  = []
    self             = false
  }
  ingress {
    description      = "ssh from myip"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["117.221.226.29/32"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}

resource "aws_security_group" "ElbSG" {
  name        = "allow_http"
  description = "allows elb to http"
  vpc_id      = aws_vpc.task_vpc.id
  ingress {
    description      = "http from internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}