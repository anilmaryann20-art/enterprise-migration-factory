resource "azurerm_network_security_group" "this" {
    name = var.network_security_group_name
    resource_group_name = var.resource_group_name
    location = var.location
}