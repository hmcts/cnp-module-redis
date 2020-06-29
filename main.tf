resource "azurerm_resource_group" "cache-resourcegroup" {
  name     = "${var.product}-cache-${var.env}"
  location = var.location

  tags = merge(var.common_tags,
    map("lastUpdated", "${timestamp()}")
  )
}


resource "azurerm_redis_cache" "redis" {
  name                = "${var.product}-${var.env}"
  location            = azurerm_resource_group.cache-resourcegroup.location
  resource_group_name = azurerm_resource_group.cache-resourcegroup.name
  capacity            = var.capacity
  family              = "P"
  sku_name            = "Premium"
  subnet_id           = var.subnetid
  enable_non_ssl_port = false
  minimum_tls_version = var.minimum_tls_version

  redis_configuration {
    maxmemory_reserved              = var.maxmemory_reserved
    maxfragmentationmemory_reserved = var.maxfragmentationmemory_reserved
    maxmemory_delta                 = var.maxmemory_delta
    maxmemory_policy = var.maxmemory_policy
  }

  tags = {
    displayName = "Redis Cache"
    environment = var.env
  }
}
