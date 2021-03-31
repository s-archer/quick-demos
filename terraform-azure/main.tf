provider "azurerm" {
  features {}
}

data "http" "myip" {
  url = "http://ipv4bot.whatismyipaddress.com"
}

resource "random_string" "password" {
  length      = 10
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

