data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.jenkins_object_id

    secret_permissions = [
      "Get", "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-username"
  value        = var.acr_username
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-password"
  value        = var.acr_password
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "vm_username" {
  name         = "vm-username"
  value        = var.vm_username
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-password"
  value        = var.vm_password
  key_vault_id = azurerm_key_vault.this.id
}

resource "azurerm_role_assignment" "jenkins_keyvault_reader" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.jenkins_object_id
}