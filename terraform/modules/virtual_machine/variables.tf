variable "network_interface_id"{
    description = "ID of the NIC"
    type = string

}

variable "resource_group_name"{
    description = "Name of the Resource Group"
    type = string
}

variable "location"{
    description = "Azure Region"
    type = string
}

variable "virtual_machine_name"{
    description = "Name of Virtual Machine"
    type = string

}
variable "vm_size"{
    description = "Size of Virtual Machine"
    type = string

}

variable "admin_username"{
    description = "Username"
    type = string

}

variable "admin_password"{
    description = "Password"
    type = string

}