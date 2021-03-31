

#
# Create a random id
#
resource random_id id {
  byte_length = 2
}

resource random_string storage {
  length      = 4
  upper       = false
  lower       = true
  number      = false
  special     = false
}
#
# Create a resource group
#
resource azurerm_resource_group rg {
  name     = format("%s-rg-%s", var.prefix, random_id.id.hex)
  location = var.location
}

resource "azurerm_virtual_network" "uksouth" {
  name                = "${var.prefix}1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  subnet {
    name           = "mgmt"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "ext"
    address_prefix = "10.0.2.0/24"
  }

  subnet {
    name           = "int"
    address_prefix = "10.0.3.0/24"
    #security_group = azurerm_network_security_group.example.id
  }

  tags = {
    environment = "Production"
    uk-se = var.uk_se_name
  }
}

data "azurerm_subnet" "mgmt" {
  name                 = "mgmt"
  virtual_network_name = azurerm_virtual_network.uksouth.name
  resource_group_name  = azurerm_resource_group.rg.name
}

data "azurerm_subnet" "ext" {
  name                 = "ext"
  virtual_network_name = azurerm_virtual_network.uksouth.name
  resource_group_name  = azurerm_resource_group.rg.name
}