resource "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_network_security_rule" "allow_ssh" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "allow_ssh"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "docker_port" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "allow_http_8080"
  priority                    = 1010
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "VM_access" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name
  name                        = "allow_http_80"
  priority                    = 1020
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}