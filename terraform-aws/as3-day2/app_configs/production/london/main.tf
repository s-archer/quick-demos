data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../terraform.tfstate"
  }
}


provider "bigip" {
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}


# resource "local_file" "as3-vs2" {
#   content = templatefile("./templates/as3_vs2.tpl", {
#     vip        = jsonencode([data.terraform_remote_state.aws_demo.outputs.f5_vs2[0]])
#     cert       = var.cert
#     key        = var.key
#     ciphertext = base64encode(var.ciphertext)
#     protected  = base64encode(var.protected)
#   })
#   filename = "./declarations/rendered-as3-vs2.json"
# }


# resource "bigip_as3" "as3-vs2" {
#   as3_json = templatefile("./templates/as3_vs2.tpl", {
#     vip        = jsonencode([data.terraform_remote_state.aws_demo.outputs.f5_vs2[0]])
#     cert       = var.cert
#     key        = var.key
#     ciphertext = base64encode(var.ciphertext)
#     protected  = base64encode(var.protected)
#   })
# }


# resource "local_file" "as3-apps" {
#   content = templatefile("./templates/as3_apps.tpl", {
#     app_list   = var.app_list

#   })
#   filename = "./declarations/rendered-as3_apps.json"
# }


# resource "bigip_as3" "as3-apps" {
#   as3_json = templatefile("./templates/as3_apps.tpl", {
#     app_list   = var.app_list
#   })
# }