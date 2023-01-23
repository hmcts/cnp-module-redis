locals {
  vnet_rg_name = var.business_area == "sds" ? "ss-${var.env}-network-rg" : "core-infra-${var.env}"
  vnet_name    = var.business_area == "sds" ? "ss-${var.env}-vnet" : "core-infra-vnet-${var.env}"
  subnet_name  = var.business_area == "sds" ? "iaas" : "core-infra-subnet-2-${var.env}"
}

data "azurerm_subnet" "private_endpoint_subnet" {
  name                 = local.subnet_name
  resource_group_name  = local.vnet_rg_name
  virtual_network_name = local.vnet_name

  count = var.private_endpoint_enabled == true ? (var.private_endpoint_subnet == "" ? 1 : 0) : 0
}

resource "azurerm_private_endpoint" "this" {
  count               = var.private_endpoint_enabled == true ? 1 : 0
  name                = "${var.product}-${var.env}"
  resource_group_name = azurerm_resource_group.cache-resourcegroup.name
  location            = azurerm_resource_group.cache-resourcegroup.location
  subnet_id           = var.private_endpoint_subnet != "" ? var.private_endpoint_subnet : data.azurerm_subnet.private_endpoint_subnet[0].id

  private_service_connection {
    name                           = "${var.product}-${var.env}"
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
