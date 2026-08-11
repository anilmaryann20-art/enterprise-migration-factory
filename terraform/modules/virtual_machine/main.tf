resource "azurerm_linux_virtual_machine" "this" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  network_interface_ids = [

    var.network_interface_id

  ]
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {

    publisher = "Canonical"

    offer = "0001-com-ubuntu-server-jammy"

    sku = "22_04-lts"

    version = "latest"

  }
  os_disk {

    caching = "ReadWrite"

    storage_account_type = "Standard_LRS"

  }
}
