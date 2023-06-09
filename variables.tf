variable "product" {
  type        = string
  description = "https://hmcts.github.io/glossary/#platform"
}

variable "location" {
  type        = string
  description = "Azure datacenter location"
}

variable "env" {
  type        = string
  description = "Environment to deploy to"
}

variable "subnetid" {
  type        = string
  description = "Subnet to deploy the Redis instance to"
  default     = ""
}

variable "common_tags" {
  type        = map(string)
  description = "Map of tags to tag all resources with"
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum TLS version"
}

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

variable "maxmemory_policy" {
  type        = string
  default     = "volatile-lru"
  description = "How Redis will select what to remove when maxmemory is reached"
}

variable "maxmemory_reserved" {
  default     = "642"
  description = "Value in megabytes reserved for non-cache usage e.g. failover"
}

variable "maxfragmentationmemory_reserved" {
  default     = "642"
  description = "Value in megabytes reserved to accommodate for memory fragmentation"
}

variable "maxmemory_delta" {
  default     = "642"
  description = "The max-memory delta for this Redis instance."
}

variable "availability_zones" {
  type        = list(any)
  default     = null
  description = "Specifies a list of Availability Zones in which this Redis Cache should be located. Changing this forces a new Redis Cache to be created."
}

variable "redis_version" {
  type        = string
  default     = "4"
  description = "Redis version to be deployed 4 or 6 (4 is deprecated)"
}

variable "private_endpoint_enabled" {
  default     = false
  description = "Deploy using a private endpoint rather than vnet integration (recommended)"
}

variable "public_network_access_enabled" {
  default     = true
  description = "Whether or not public network access is allowed for this Redis Cache. `true` means this resource could be accessed by both public and private endpoint. `false` means only private endpoint access is allowed. Defaults to `true`."
}

variable "private_endpoint_subnet" {
  default     = ""
  description = "Specify your own subnet for private link integration, if you don't specify one then it will be calculated for you."
}

variable "business_area" {
  default     = "cft"
  description = "business_area name - sds or cft"
}

variable "resource_group_name" {
  description = "Name of existing resource group to deploy resources into"
  type        = string
  default     = null
}