variable "subnet_name"{
    description = "Name of the subnet"
    type = string

}

variable "resource_group_name"{
    description = "Name of the Resource Group"
    type = string
    }

variable "address_prefixes"{
    description = "address prefixes"
    type = list(string)
}

variable "virtual_network_name"{
    description = "Name of the virtual network"
    type = string
}
