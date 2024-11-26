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
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  redis_version                 = var.redis_version
  zones                         = var.availability_zones

  redis_configuration {
    data_persistence_authentication_method = var.data_persistence_authentication_method
    maxmemory_reserved              = var.maxmemory_reserved
    maxfragmentationmemory_reserved = var.maxfragmentationmemory_reserved
    maxmemory_delta                 = var.maxmemory_delta
    maxmemory_policy                = var.maxmemory_policy
  }

  tags = var.common_tags
}
