variable "key_vault_name" {
  description = "Key Vault Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "jenkins_object_id" {
  description = "Object ID of Jenkins Service Principal"
  type        = string
}

variable "acr_username" {
  description = "ACR Admin Username"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "ACR Admin Password"
  type        = string
  sensitive   = true
}

variable "vm_username" {
  description = "VM Admin Username"
  type        = string
  sensitive   = true
}

variable "vm_password" {
  description = "VM Admin Password"
  type        = string
  sensitive   = true
}