data "aws_ami" "f5_ami" {
  most_recent = true
  # This is the F5 Networks 'owner ID', which ensures we get an image maintained by F5.
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = [var.f5_ami_search_name]
  }
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

resource "random_string" "password" {
  length  = 10
  special = false
}



