# moj-module-redis

This repository contains the module that enables you to create a Redis PaaS instance.

## Variables

### Configuration

The following parameters are required by the module

-	`product` this is the name of the product or project i.e. probate, divorce etc.
-	`location` this is the azure region for this service
- `env` this is used to differentiate the environments e.g dev, prod, test etc
- `subnetid` the id of the subnet in which to create the Redis instance
- `common_tags` tags that need to be applied to every resource group, passed through by the jenkins-library

### Output

The following values are provided by the module for use in other modules

- `host_name` the host name which can be used to connect to Redis
- `access_key` the primary access key required to connect
- `redis_port` the port on which Redis is running

## Usage

The following example shows how to use the module to create a Redis PaaS instance and expose
the host, port and access key as environment variables in another module.

```terraform
module "redis-cache" {
  source      = "git@github.com:contino/moj-module-redis?ref=master"
  product     = "${var.product}"
  location    = "${var.location}"
  env         = "${var.env}"
  subnetid    = "${data.terraform_remote_state.core_apps_infrastructure.subnet_ids[2]}"
  common_tags = "${var.common_tags}"
}

module "frontend" {
  source      = "git@github.com:contino/moj-module-webapp?ref=0.0.78"
  product     = "${var.product}-frontend"
  location    = "${var.location}"
  env         = "${var.env}"
  asename     = "${data.terraform_remote_state.core_apps_compute.ase_name[0]}"
  common_tags = "${var.common_tags}"

  app_settings = {
    REDIS_HOST                   = "${module.redis-cache.host_name}"
    REDIS_PORT                   = "${module.redis-cache.redis_port}"
    REDIS_PASSWORD               = "${module.redis-cache.access_key}"
  }
}
```
