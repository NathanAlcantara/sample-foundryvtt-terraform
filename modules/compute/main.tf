resource "tls_private_key" "foundry" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = "mkdir -p ./keys"
  }

  provisioner "local-exec" {
    command = "echo '${self.public_key_openssh}' > ./keys/foundry.rsa"
  }

  provisioner "local-exec" {
    command = "echo '${self.private_key_pem}' > ./keys/foundry.pem"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "foundry"
  public_key = tls_private_key.foundry.public_key_openssh
}

data "aws_ami" "ubuntu-20-04" {
  owners = ["099720109477"]

  filter {
    name   = "image-id"
    values = ["ami-042e8287309f5df03"]
  }
}

resource "aws_security_group" "foundry" {
  name = "foundry-sg"

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "foundry" {
  ami                    = data.aws_ami.ubuntu-20-04.id
  instance_type          = var.foundry_int_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.foundry.id]

  tags = {
    Name = "FoundryVTT"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.local/share/FoundryVTT/Config",
      "mkdir /home/ubuntu/foundry",
    ]
  }

  provisioner "file" {
    source      = "files/aws.json"
    destination = "/home/ubuntu/.local/share/FoundryVTT/Config/aws.json"
  }

  provisioner "file" {
    source      = "files/foundryvtt.zip"
    destination = "/home/ubuntu/foundry/foundryvtt.zip"
  }

  provisioner "file" {
    source      = "files/foundry_install_start.sh"
    destination = "/tmp/foundry_install_start.sh"
  }

  provisioner "file" {
    source      = "files/nginx_config.sh"
    destination = "/tmp/nginx_config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/foundry_install_start.sh",
      "sudo bash /tmp/nginx_config.sh ${aws_instance.foundry.public_dns}",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = file("./keys/foundry.pem")
    host        = self.public_ip
  }
}
