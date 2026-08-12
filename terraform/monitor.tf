module "log_analytics" {
  source = "./modules/log_analytics"

  workspace_name      = var.log_analytics_workspace_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
}

# Action Group - WHO gets notified
resource "azurerm_monitor_action_group" "email_alert" {
  name                = "emf-action-group"
  resource_group_name = var.resource_group_name
  short_name          = "emf-alert"

  email_receiver {
    name          = "Maryann"
    email_address = "anilmaryann20@gmail.com"
  }
}

# CPU Alert - fires when CPU goes above 80%
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "emf-high-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [module.virtual_machine.virtual_machine_id]
  description         = "Alert when CPU exceeds 80%"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }
}

# Memory Alert - fires when memory goes above 90%
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "emf-high-memory-alert"
  resource_group_name = var.resource_group_name
  scopes              = [module.virtual_machine.virtual_machine_id]
  description         = "Alert when memory exceeds 90%"
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 500000000
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }
}