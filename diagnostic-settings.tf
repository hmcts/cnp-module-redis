resource "azurerm_monitor_diagnostic_setting" "redis-ds" {
  name                       = "${var.product}-${var.env}"
  target_resource_id         = azurerm_redis_cache.redis.id
  log_analytics_workspace_id = module.log_analytics_workspace.workspace_id

  log {
    category = "ConnectedClientList"

    retention_policy {
      enabled = true
      days    = 14
    }
  }
}

module "log_analytics_workspace" {
  source      = "git::https://github.com/hmcts/terraform-module-log-analytics-workspace-id.git?ref=master"
  environment = var.env
}