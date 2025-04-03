data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../terraform.tfstate"
  }
}

terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.22.1"
    }
  }
  required_version = ">= 0.13"
}

provider "bigip" {
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}


resource "bigip_as3" "as3-per-app-1" {
  tenant_name = "test"
  as3_json = templatefile("./templates/as3_apps.tpl", {
    app_list = var.app_list_1
  })
}

resource "bigip_as3" "as3-per-app-3" {
  tenant_name = "test"
  as3_json = templatefile("./templates/as3_apps.tpl", {
    app_list = var.app_list_2
  })
}