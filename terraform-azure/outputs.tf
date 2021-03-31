output bigip_password {
   value = module.bigip[*].bigip_password
}

output onboard_do {
   value = module.bigip[*].onboard_do
}