variable "network_interface_name" {
  description = "Name of the NIC"
  type        = string

}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string

}
variable "public_ip_id" {
  type = string
}