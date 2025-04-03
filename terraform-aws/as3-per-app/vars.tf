variable "cert" {
  type = string
}

variable "key" {
  type = string
}

variable "ciphertext" {
  type = string
}

variable "protected" {
  type = string
}

variable "vip" {
  type = string
}

variable "app_list_1" {
  description = "list of applications to be deployed onto shared VIP"
  type = list(object({
    app_short_name        = string
    private_ip            = string
    fqdn                  = string
    certificate           = string
    key                   = string
    passphrase            = string
    protected             = string
    service_discovery_tag = string
    region                = string
    waf_enable            = bool
  }))
}

variable "app_list_2" {
  description = "list of applications to be deployed onto shared VIP"
  type = list(object({
    app_short_name        = string
    private_ip            = string
    fqdn                  = string
    certificate           = string
    key                   = string
    passphrase            = string
    protected             = string
    service_discovery_tag = string
    region                = string
    waf_enable            = bool
  }))
}