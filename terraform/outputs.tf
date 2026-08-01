output "resource_group_name" {
    description = "Name of the Resource Group"
    value = azurerm_resource_group.emf_rg.name
}

output "resource_group_id"{
    description = "ID of the resource group"
    value = azurerm_resource_group.emf_rg.id
}