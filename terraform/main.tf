module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source = "./modules/storage_account"

  storage_account_name = var.storage_account_name

  resource_group_name = module.resource_group.resource_group_name

  location = var.location
}
module "virtual_network" {
  source = "./modules/virtual_network"

  virtual_network_name = var.virtual_network_name

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  address_space = var.address_space
}

module "subnet" {
  source = "./modules/subnet"

  subnet_name = var.subnet_name

  virtual_network_name = module.virtual_network.virtual_network_name

  resource_group_name = module.resource_group.resource_group_name

  address_prefixes = var.address_prefixes
}

module "network_security_group" {
  source = "./modules/networK_security_group"
  network_security_group_name = var.network_security_group_name
  resource_group_name = module.resource_group.resource_group_name
  location = var.location

}

module "subnet_nsg_association" {
  source = "./modules/subnet_nsg_association"
  network_security_group_id = module.network_security_group.network_security_group_id
  subnet_id = module.subnet.subnet_id
}

module "network_interface" {
  source = "./modules/network_interface"

  network_interface_name = var.network_interface_name

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  subnet_id = module.subnet.subnet_id

  public_ip_id = module.public_ip.public_ip_id
}

module "virtual_machine" {
  source = "./modules/virtual_machine"

  virtual_machine_name = var.virtual_machine_name

  resource_group_name = module.resource_group.resource_group_name

  location = var.location

  network_interface_id = module.network_interface.network_interface_id

  vm_size = var.vm_size

  admin_username = var.admin_username

  admin_password = var.admin_password
}

module "public_ip" {
  source = "./modules/public_ip"

  public_ip_name = var.public_ip_name

  resource_group_name = module.resource_group.resource_group_name

  location = var.location
}