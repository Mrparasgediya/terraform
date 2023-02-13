data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default_vpc_data" {
  default = true
}

data "aws_subnet" "default_subnet" {
  id     = "subnet-034e185bc2d4644cb" // AZ: ap-south-1
  vpc_id = data.aws_vpc.default_vpc_data.id
}

resource "aws_security_group" "instance_security_group" {
  name        = "instance_security_group"
  description = "security group that allow server on port 8080"
  vpc_id      = data.aws_vpc.default_vpc_data.id

  ingress {
    description      = "https port"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "http port"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ssh port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "pokemon_app_ec2" {
  ami             = data.aws_ami.ubuntu.id
  subnet_id       = data.aws_subnet.default_subnet.id
  instance_type   = "t2.micro"
  key_name        = "aayush_paras"
  security_groups = [aws_security_group.instance_security_group.id]
}