variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}
variable "storage_account_name" {
  description = "Storage Account Name"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "address_space" {
  description = "Vnet address space"
  type        = list(string)
}
variable "subnet_name" {
  description = "Subent Name"
  type        = string
}

variable "address_prefixes" {
  description = "address prefixes"
  type        = list(string)
}

variable "network_security_group_name" {
  description = "Network security group"
  type        = string
}

variable "network_interface_name" {
  description = "Network Interface Name"
  type        = string
}

variable "virtual_machine_name" {
  description = "Virtual Machine Name"
  type        = string
}

variable "vm_size" {
  description = "Virtual Machine Size"
  type        = string
}

variable "admin_username" {
  description = "Administrator Username"
  type        = string
}

variable "admin_password" {
  description = "Administrator Password"
  type        = string
}

variable "public_ip_name" {
  description = "Public IP Name"
  type        = string
}

variable "acr_name" {
  description = "Azure Container Registry"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
}

