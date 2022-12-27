locals {
  vpc_id           = "<VPC_ID>"
  subnet_id        = "<SUBNET_ID>"
  ssh_user         = "S<SH_USER>"
  key_name         = "<KEYPAIR>"
  private_key_path = "<KEYPAIR PATH>"
}


provider "aws" {
  region  = "us-east-2"
  profile = "<AWS CONFIG PROFILES"
}

resource "aws_security_group" "nginx" {
  name   = "nginx-access"
  vpc_id = local.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "nginx" {
  ami                         = "<AMI_ID>"
  subnet_id                   = local.subnet_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nginx.id]
  key_name                    = local.key_name

  provisioner "remote-exec" {
    inline = ["echo wait until ssh is ready"]
    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.nginx.public_ip

    }


  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx.yaml"

  }

}

output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

