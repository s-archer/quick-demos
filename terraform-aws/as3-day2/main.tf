data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform.tfstate"
  }
}

provider "bigip" {
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}


data "template_file" "vs2" {
  template = file("./as3_vs2.tpl")

  vars = {
    vs2_ip = jsonencode([data.terraform_remote_state.aws_demo.outputs.f5_vs2[0]])
  }
}


resource "bigip_as3" "nginx" {
  as3_json = data.template_file.vs2.rendered
}
