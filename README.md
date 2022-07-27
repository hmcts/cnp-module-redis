# cnp-module-redis

This repository contains the module that enables you to create a Redis PaaS instance.

## Variables

### Configuration

The following parameters are required by the module

-	`product` this is the name of the product or project i.e. probate, divorce etc.
-	`location` this is the azure region for this service
- `env` this is used to differentiate the environments e.g dev, prod, test etc
- `subnetid` the id of the subnet in which to create the Redis instance
- `common_tags` tags that need to be applied to every resource group, passed through by the jenkins-library
- `availability_zones` defaults to `null` Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created.

### Output

The following values are provided by the module for use in other modules

- `host_name` the host name which can be used to connect to Redis
- `access_key` the primary access key required to connect
- `redis_port` the port on which Redis is running

## Usage

The following example shows how to use the module to create a Redis PaaS instance and expose
the host, port and access key as environment variables in another module.

```terraform
data "azurerm_subnet" "subnet" {
  name                 = "core-infra-subnet-1-${var.env}"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

module "redis-cache" {
  source      = "git@github.com:hmcts/cnp-module-redis?ref=master"
  product     = var.product
  location    = var.location
  env         = var.env
  subnetid    = data.azurerm_subnet.core_infra_redis_subnet.id
  common_tags = var.common_tags
}

resource "azurerm_key_vault_secret" "redis_access_key" {
  name         = "redis-access-key"
  value        = module.redis-activity-service.access_key
  key_vault_id = data.azurerm_key_vault.vault.id
}
```
