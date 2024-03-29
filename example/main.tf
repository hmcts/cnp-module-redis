module "redis" {
  source        = "../"
  product       = var.product
  location      = var.location
  env           = var.env
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
