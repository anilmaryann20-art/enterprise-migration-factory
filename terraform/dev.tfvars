resource_group_name = "rg-emf-terraform-dev"

location = "Central India"

storage_account_name = "stordev001"

virtual_network_name = "vnet-emf-dev"

address_space = [ "10.0.0.0/16"]

subnet_name = "subnet-emf-dev"

address_prefixes = [
  "10.0.1.0/24"
]

network_security_group_name = "vnet-nsg-dev"

network_interface_name = "nic-emf-dev"

virtual_machine_name = "vm-emf-dev"

vm_size = "Standard_B2as_v2"

admin_username = "azureuser"

admin_password = "YourStrongPassword123!"