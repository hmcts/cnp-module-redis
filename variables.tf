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
