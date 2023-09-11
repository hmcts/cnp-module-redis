locals {
  vnet_rg_name = var.business_area == "sds" ? "ss-${var.env}-network-rg" : "cft-${var.env}-network-rg"
  vnet_name    = var.business_area == "sds" ? "ss-${var.env}-vnet" : "cft-${var.env}-vnet"
  subnet_name  = var.business_area == "sds" ? "iaas" : "private-endpoints"
}

data "azurerm_subnet" "private_endpoint_subnet_temp" {
  name                 = local.subnet_name
  resource_group_name  = local.vnet_rg_name
  virtual_network_name = local.vnet_name

  count = var.private_endpoint_enabled == true && var.product == "rpx-mc-redis6" ? (var.private_endpoint_subnet == "" ? 1 : 0) : 0
}

resource "azurerm_private_endpoint" "this" {
  count               = var.private_endpoint_enabled == true && var.product == "rpx-mc-redis6" ? 1 : 0
  name                = "${var.product}-${var.env}-temp"
  resource_group_name = var.resource_group_name != null ? var.resource_group_name : azurerm_resource_group.cache-resourcegroup[0].name
  location            = var.location
  subnet_id           = var.private_endpoint_subnet != "" ? var.private_endpoint_subnet : data.azurerm_subnet.private_endpoint_subnet_temp[0].id

  private_service_connection {
    name                           = "${var.product}-${var.env}-temp"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  private_dns_zone_group {
    name                 = "redis-endpoint-dnszonegroup"
    private_dns_zone_ids = ["/subscriptions/1baf5470-1c3e-40d3-a6f7-74bfbce4b348/resourceGroups/core-infra-intsvc-rg/providers/Microsoft.Network/privateDnsZones/privatelink.redis.cache.windows.net"]
  }

  tags = var.common_tags
}
