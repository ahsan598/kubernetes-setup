data "aws_vpc" "default" {
  default = true
}

provider "aws" {
  region = var.region
}

# Control Plane
resource "aws_instance" "master" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = "k8s-master"
    Role = "master"
  }
}

# Worker Nodes
resource "aws_instance" "workers" {
  count         = 2
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}
