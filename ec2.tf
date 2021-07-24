variable "instance_ami" {
  default = "ami-03bbe60df80bdccc0"
}

resource "aws_key_pair" "developer_keypair" {
  key_name   = "developer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCigWIwCDN7ME+WVisrQzZVEvjfRPkhkMSdJjnz0a4SvaCvbCVPXJ/xZpqAtmnT8gir0s+MaAdyAYEmqbnoI/m30vuINRQ9w8tFUSjuw/9fQO2wZHpoS+PvPpM1XnOeGpLLf3zmjVOvyPOooO9ufs+W+0bZPb2emhaViUqflMsqQ8a2O2gc7jH1bktAeb7/KwUCMJAs/m6/07kNgQ/fJ3LaJF2w7vg1KQq831gZxR6mbBJIttuctymqJcUGwxBRWTxi19GgQdz4og+DjaKBsdjaBn1UYs0YB304iImULXouWo6caK1+i7eohS1vPIWVJ6iCSN8Qs51ofGIC22+1iSwo/GBiePHiBnqM9JcC0wBDCKqJdxTnLc12eU2T2djd/weYmkQOzJ7AeDufHToEF/fV8GzZcveQosBtTamat2UmhzhpKHUdtMOaDpXq3cchmdx0f7wE7u/YuAgEny64LgF4zmqo25OEh+cYRcbUFi0w5ny1j5jqwiPHtlpFLKLAO4jQWfNFRPVLcgEUhMSzkNh3O6dfRnKByUsj4AU+3ajuyehoncrtKZyziPEQfmbAbMmHBar0KiXvVw1m++3F2AcsaYBZ4HvRlQ2uS2HjvtiMs5si+sU8jC8jF+dLp6wDNsw2z7vaJ1sm1bUmLJa3gQFVA29c0/EazKdcVgFxfakAHw== jrywm121@gmail.com"
}

resource "aws_security_group" "isucon_qualify_instance_sg" {
  name        = "allow_ssh_app"
  description = "For Isucon"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8000
    to_port          = 8000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 9091
    to_port          = 9091
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

resource "aws_eip" "isucon_qualify_instance_eip" {
  instance   = aws_instance.isucon_qualify_instance.id
  vpc        = true
  depends_on = [module.vpc]
}

resource "aws_instance" "isucon_qualify_instance" {
  ami                    = var.instance_ami
  instance_type          = "c5.large"
  key_name               = aws_key_pair.developer_keypair.key_name
  vpc_security_group_ids = [aws_security_group.isucon_qualify_instance_sg.id]
  subnet_id              = element(module.vpc.public_subnets, 0)
}
