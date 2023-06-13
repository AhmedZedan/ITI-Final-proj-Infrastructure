data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [ var.filter ]
  }

  owners = [ var.owner ]
}

resource "aws_instance" "bastion_server" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.allow_http_ssh_SG.id]
  
  tags = {
    Name = var.bastion_name
  }
}