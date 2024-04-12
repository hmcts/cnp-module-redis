resource "azurerm_resource_group" "cache-resourcegroup" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.product}-cache-${var.env}"
  location = var.location
  tags     = var.common_tags
}

resource "azurerm_storage_account" "backup" {
  count                    = var.rdb_backup_enabled ? 1 : 0
  name                     = "${var.rdb_storage_account_name_prefix}${var.env}redissa"
  resource_group_name      = azurerm_resource_group.cache-resourcegroup[0].name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.common_tags
}

resource "azurerm_redis_cache" "redis" {
  name                          = var.name != null ? var.name : "${var.product}-${var.env}"
  location                      = var.location
  resource_group_name           = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.cache-resourcegroup[0].name
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  subnet_id                     = var.private_endpoint_enabled ? null : var.subnetid
  enable_non_ssl_port           = false
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  redis_version                 = var.redis_version
  zones                         = var.availability_zones

  redis_configuration {
    maxmemory_reserved              = var.maxmemory_reserved
    maxfragmentationmemory_reserved = var.maxfragmentationmemory_reserved
    maxmemory_delta                 = var.maxmemory_delta
    maxmemory_policy                = var.maxmemory_policy
    rdb_backup_enabled              = var.rdb_backup_enabled
    rdb_storage_connection_string   = var.rdb_backup_enabled ? azurerm_storage_account.backup[0].primary_connection_string : null
    rdb_backup_frequency            = var.rdb_backup_enabled ? var.rdb_backup_frequency : null
  }

  tags = var.common_tags
}
