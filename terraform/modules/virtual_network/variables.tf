variable "virtual_network_name"{
    description = "Name of the virtual network"
    type = string
}

variable "resource_group_name"{
    description = "Name of the resource group"
    type = string
}

variable "location"{
    description = "Azure Region"
    type = string
}

variable "address_space"{
    description = "address space"
    type = list(string)
    
}