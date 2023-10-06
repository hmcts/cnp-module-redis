# cnp-module-redis

This repository contains the module that enables you to create a Redis PaaS instance.

## Usage

### Recommended example for cost optimisation

Premium redis PaaS instance are very expensive, care **must** be taken when using them and only used in required environments.
This should only be production unless you **really** need it in a different environment.

variables.tf

```
variable "family" {
  default     = "P"
  description = "The SKU family/pricing group to use. Valid values are `C` (for Basic/Standard SKU family) and `P` (for Premium). Use P for higher availability, but beware it costs a lot more."
}

variable "sku_name" {
  default     = "Premium"
  description = "The SKU of Redis to use. Possible values are `Basic`, `Standard` and `Premium`."
}

variable "capacity" {
  default     = "1"
  description = "The size of the Redis cache to deploy. Valid values are 1, 2, 3, 4, 5"
}
```
The following values are recommended for use in lower environments when using a **Basic** sku.

ithc.tfvars
```
sku_name = "Basic"
family   = "C"
capacity = "3"
```
The following values are recommended for use in lower environments when using a **Standard** sku.

demo.tfvars
```
sku_name = "Standard"
family   = "C"
capacity = "3"
```

The following example shows how to use the module to create a Redis PaaS instance and expose the host, port and access key as environment variables in another module.

```terraform
module "redis" {
  source                   = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product                  = var.product
  location                 = var.location
  env                      = var.env
  common_tags              = var.common_tags
  redis_version            = "6"
  business_area            = "cft" # cft or sds
  sku_name                 = var.sku_name
  family                   = var.family
  capacity                 = var.capacity
  private_endpoint_enabled      = true
  public_network_access_enabled = false
}

resource "azurerm_key_vault_secret" "redis_access_key" {
  name         = "redis-access-key"
  value        = module.redis-activity-service.access_key
  key_vault_id = data.azurerm_key_vault.vault.id
}
```

### Configuration

<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_redis_cache.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.cache-resourcegroup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.private_endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created. | `list(any)` | `null` | no |
| <a name="input_business_area"></a> [business\_area](#input\_business\_area) | business\_area name - sds or cft | `string` | `"cft"` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The size of the Redis cache to deploy. Valid values are 1, 2, 3, 4, 5 | `string` | `"1"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of tags to tag all resources with | `map(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment to deploy to | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The SKU family/pricing group to use. Valid values are `C` (for Basic/Standard SKU family) and `P` (for Premium). Use P for higher availability, but beware it costs a lot more. | `string` | `"P"` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure datacenter location | `string` | n/a | yes |
| <a name="input_maxfragmentationmemory_reserved"></a> [maxfragmentationmemory\_reserved](#input\_maxfragmentationmemory\_reserved) | Value in megabytes reserved to accommodate for memory fragmentation | `string` | `"642"` | no |
| <a name="input_maxmemory_delta"></a> [maxmemory\_delta](#input\_maxmemory\_delta) | The max-memory delta for this Redis instance. | `string` | `"642"` | no |
| <a name="input_maxmemory_policy"></a> [maxmemory\_policy](#input\_maxmemory\_policy) | How Redis will select what to remove when maxmemory is reached | `string` | `"volatile-lru"` | no |
| <a name="input_maxmemory_reserved"></a> [maxmemory\_reserved](#input\_maxmemory\_reserved) | Value in megabytes reserved for non-cache usage e.g. failover | `string` | `"642"` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The minimum TLS version | `string` | `"1.2"` | no |
| <a name="input_name"></a> [name](#input\_name) | Override the default name of `$product-$env`, useful when upgrading versions | `string` | `null` | no |
| <a name="input_private_endpoint_enabled"></a> [private\_endpoint\_enabled](#input\_private\_endpoint\_enabled) | Deploy using a private endpoint rather than vnet integration (recommended) | `bool` | `false` | no |
| <a name="input_private_endpoint_subnet"></a> [private\_endpoint\_subnet](#input\_private\_endpoint\_subnet) | Specify your own subnet for private link integration, if you don't specify one then it will be calculated for you. | `string` | `""` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#platform | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether or not public network access is allowed for this Redis Cache. `true` means this resource could be accessed by both public and private endpoint. `false` means only private endpoint access is allowed. Defaults to `true`. | `bool` | `true` | no |
| <a name="input_redis_version"></a> [redis\_version](#input\_redis\_version) | Redis version to be deployed 4 or 6 (4 is deprecated) | `string` | `"4"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of existing resource group to deploy resources into | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of Redis to use. Possible values are `Basic`, `Standard` and `Premium`. | `string` | `"Premium"` | no |
| <a name="input_subnetid"></a> [subnetid](#input\_subnetid) | Subnet to deploy the Redis instance to | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key"></a> [access\_key](#output\_access\_key) | Primary access key to connect to redis with |
| <a name="output_host_name"></a> [host\_name](#output\_host\_name) | Host name of the Redis cache |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | SSL port to connect to redis with |
<!-- END_TF_DOCS -->

