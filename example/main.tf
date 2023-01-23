data "azurerm_subnet" "redis_subnet" {
  name                 = "core-infra-subnet-2-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

module "redis" {
  source        = "../"
  product       = var.product
  location      = var.location
  env           = var.env
  subnetid      = data.azurerm_subnet.redis_subnet.id
  common_tags   = module.tags.common_tags
  redis_version = "6"
  business_area = "cft"
  family        = "C"
  sku_name      = "Basic"

  private_endpoint_enabled      = true
  public_network_access_enabled = false
}

# projects run on Jenkins do not need this module should and should just pass through var.common_tags instead
module "tags" {
  source       = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment  = var.env
  product      = var.product
  builtFrom    = var.builtFrom
  expiresAfter = "2023-01-30"
}
