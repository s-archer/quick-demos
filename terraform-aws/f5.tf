data "aws_ami" "f5_ami" {
  most_recent = true
  # This is the F5 Networks 'owner ID', which ensures we get an image maintained by F5.
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
}

resource "aws_network_interface" "mgmt" {
  subnet_id       = module.vpc.public_subnets[0]
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.mgmt.id]
}

resource "aws_network_interface" "external" {
  subnet_id = module.vpc.public_subnets[1]
  #private_ips     = ["10.0.2.10", "10.0.2.101", "10.0.2.102"]
  private_ips_count = 2
  security_groups   = [aws_security_group.external.id]
}

resource "aws_network_interface" "internal" {
  subnet_id   = module.vpc.private_subnets[0]
  private_ips = ["10.0.3.10"]
}

resource "aws_eip" "mgmt" {
  vpc                       = true
  network_interface         = aws_network_interface.mgmt.id
  associate_with_private_ip = "10.0.1.10"
}

resource "aws_eip" "external-self" {
  vpc               = true
  network_interface = aws_network_interface.external.id
  #associate_with_private_ip = "10.0.2.10"
  associate_with_private_ip = element(tolist(aws_network_interface.external.private_ips), 0)
}

resource "aws_eip" "external-vs1" {
  vpc               = true
  network_interface = aws_network_interface.external.id
  #associate_with_private_ip = "10.0.2.101"
  associate_with_private_ip = element(tolist(aws_network_interface.external.private_ips), 1)
}

resource "aws_eip" "external-vs2" {
  vpc               = true
  network_interface = aws_network_interface.external.id
  #associate_with_private_ip = "10.0.2.102"
  associate_with_private_ip = element(tolist(aws_network_interface.external.private_ips), 2)
}

data "template_file" "do" {
  template = file("./templates/do.tpl")
}

data "template_file" "as3" {
  template = file("./templates/as3.tpl")
}

data "template_file" "f5_init" {
  template = file("./templates/user_data_json.tpl")

  vars = {
    hostname        = var.hostname-f5,
    admin_pass      = random_string.password.result,
    external_ip     = "${aws_network_interface.external.private_ip}/24",
    internal_ip     = "${aws_network_interface.internal.private_ip}/24",
    internal_gw     = cidrhost(module.vpc.private_subnets_cidr_blocks[0], 1),
    vs1_ip          = aws_eip.external-vs1.private_ip,
    access_key      = var.aws_access_key,
    secret_key      = var.aws_secret_key,
    do_declaration  = data.template_file.do.rendered,
    as3_declaration = data.template_file.as3.rendered
  }
}


resource "aws_instance" "f5" {

  ami       = data.aws_ami.f5_ami.id
  user_data = data.template_file.f5_init.rendered

  instance_type = var.instance_type
  key_name      = aws_key_pair.demo.key_name
  root_block_device { delete_on_termination = true }

  network_interface {
    network_interface_id = aws_network_interface.mgmt.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.external.id
    device_index         = 1
  }

  network_interface {
    network_interface_id = aws_network_interface.internal.id
    device_index         = 2
  }

  # Checks that AS3 API is available 
  # provisioner "local-exec" {
  #   command = "while [[ \"$(curl -skiu admin:${random_string.password.result} https://${self.public_ip}/mgmt/shared/appsvcs/declare | grep -Eoh \"^HTTP/1.1 20\")\" != \"HTTP/1.1 20\" ]]; do sleep 5; done"
  # }

  # Checks that AS3 App is available 
  provisioner "local-exec" {
    command = "while [[ \"$(curl -ski http://${aws_eip.external-vs1.public_ip} | grep -Eoh \"^HTTP/1.1 200\")\" != \"HTTP/1.1 200\" ]]; do sleep 5; done"
  }

  tags = {
    Name  = "${var.prefix}-f5"
    Env   = "aws"
    UK-SE = var.uk_se_name
  }
}

# For testing, writes out to file.
#
resource "local_file" "test_user_debug" {
  content = templatefile("./templates/user_data_json.tpl", {
    hostname        = var.hostname-f5,
    admin_pass      = random_string.password.result,
    external_ip     = "${aws_network_interface.external.private_ip}/24",
    internal_ip     = "${aws_network_interface.internal.private_ip}/24",
    internal_gw     = cidrhost(module.vpc.public_subnets_cidr_blocks[1], 1),
    vs1_ip          = aws_eip.external-vs1.private_ip,
    access_key      = var.aws_access_key,
    secret_key      = var.aws_secret_key,
    do_declaration  = data.template_file.do.rendered,
    as3_declaration = data.template_file.as3.rendered
  })
  filename = "${path.module}/user_data_debug.json"
}