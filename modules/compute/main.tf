resource "tls_private_key" "foundry" {
  algorithm = "RSA"
  rsa_bits  = 4096

  provisioner "local-exec" {
    command = "mkdir -p ./keys"
  }

  provisioner "local-exec" {
    command = "echo '${self.private_key_pem}' > ./keys/foundry.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 ./keys/foundry.pem"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "foundry"
  public_key = tls_private_key.foundry.public_key_openssh
}

module "security_group_instance" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "foundry-ec2"
  vpc_id = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port = 30000
      to_port   = 30000
      protocol  = "tcp"
    },
  ]

  egress_rules = ["all-all"]
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "FoundryVTT"

  ami           = "ami-0b72821e2f351e396"
  instance_type = var.foundry_int_type
  key_name      = aws_key_pair.generated_key.key_name

  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [module.security_group_instance.security_group_id]

  associate_public_ip_address = true

  root_block_device = [
    {
      volume_size = var.foundry_volume_size
      volume_type = "gp3"
      encrypted   = true
    }
  ]
}

resource "null_resource" "foundry_post_creation_exec" {
  triggers = {
    ec2_instance_id    = module.ec2_instance.id
    scripts_dir_sha256 = sha256(join("", [for f in fileset(path.root, "scripts/*") : filebase64sha256(f)]))
    files_dir_sha256   = sha256(join("", [for f in fileset(path.root, "files/*") : filebase64sha256(f)]))
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/.local/share/FoundryVTT/Config",
      "mkdir -p /home/ec2-user/foundryvtt",
      "mkdir -p /home/ec2-user/scripts",
      "mkdir -p /home/ec2-user/files",
    ]
  }

  provisioner "local-exec" {
    command = "bash scripts/setup_aws_cred.sh ${var.foundry_key} ${var.foundry_secret}"
  }

  provisioner "file" {
    source      = "files/aws.json"
    destination = "/home/ec2-user/.local/share/FoundryVTT/Config/aws.json"
  }

  provisioner "file" {
    source      = "files/foundryvtt.zip"
    destination = "/home/ec2-user/foundryvtt/foundryvtt.zip"
  }

  provisioner "file" {
    source      = "files/foundry_install_start.sh"
    destination = "/tmp/foundry_install_start.sh"
  }

  provisioner "file" {
    source      = "files/worlds_backup.sh"
    destination = "/home/ec2-user/scripts/worlds_backup.sh"
  }

  provisioner "file" {
    source      = "files/initiate_world.sh"
    destination = "/home/ec2-user/scripts/initiate_world.sh"
  }

  provisioner "file" {
    source      = "files/foundry-setup.json"
    destination = "/home/ec2-user/files/foundry-setup.json"
  }

  provisioner "file" {
    source      = "files/setup_crontab.sh"
    destination = "/tmp/setup_crontab.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/foundry_install_start.sh",
      "bash /tmp/setup_crontab.sh ${var.foundry_domain_name}",
      "pm2 restart foundry"
    ]
  }

  provisioner "local-exec" {
    command = "bash scripts/foundry_license_config.sh ${var.foundry_domain_name}"
  }

  provisioner "local-exec" {
    command = "bash scripts/install_environment.sh ${var.foundry_domain_name}"
  }

  provisioner "local-exec" {
    command = "bash scripts/import_worlds.sh ${module.ec2_instance.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo {\"awsConfig\":\"/home/ec2-user/.local/share/FoundryVTT/Config/aws.json\"} > /tmp/options.json",
      "jq -s '.[0] * .[1]' ~/.local/share/FoundryVTT/Config/options.json /tmp/options.json > ~/.local/share/FoundryVTT/Config/options.json.tmp",
      "mv ~/.local/share/FoundryVTT/Config/options.json.tmp ~/.local/share/FoundryVTT/Config/options.json",
      "rm /tmp/options.json",
      "pm2 restart foundry",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.foundry.private_key_pem
    host        = module.ec2_instance.public_ip
  }
}
