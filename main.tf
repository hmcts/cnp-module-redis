resource "azurerm_resource_group" "cache-resourcegroup" {
  count    = var.resource_group_name == null ? 1 : 0
  name     = "${var.product}-cache-${var.env}"
  location = var.location
  tags     = var.common_tags
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
  }

  tags = var.common_tags

  # Create storage account if rdb_backup_enabled is true
  dynamic "redis_rdb" {
    for_each = var.rdb_backup_enabled == true ? [1] : []
    content {
      storage_account_name      = "${var.product}${var.env}redisrdb"
      storage_account_replication_type = "LRS"
      storage_account_tier      = "Standard"
      storage_account_kind      = "StorageV2"

      # Connection string for the storage account
      storage_account_connection_string = azurerm_storage_account.redis_rdb_connection_string[0].primary_connection_string
    }
  }
}

# Create storage account if rdb_backup_enabled is true
resource "azurerm_storage_account" "redis_rdb_connection_string" {
  count                 = var.rdb_backup_enabled == true ? 1 : 0
  name                  = "${var.product}${var.env}redisrdb"
  resource_group_name   = azurerm_resource_group.cache-resourcegroup[0].name
  location              = var.location
  account_tier          = "Standard"
  account_replication_type = "LRS"
  account_kind          = "StorageV2"

  tags = var.common_tags
}