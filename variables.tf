variable "product" {
  type = string
}

variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "subnetid" {
  type = string
}

variable "common_tags" {
  type = map
}

variable "minimum_tls_version" {
  type = string
  default = "1.0"
}

variable "capacity" {
  type = number
  default = 1
}

variable "maxmemory_policy" {
  type = string
  default = "volatile-lru"
}

variable "maxmemory_reserved" {
  type = number
  default = 200
}

variable "maxfragmentationmemory_reserved" {
  type = number
  default = 300
}

variable "maxmemory_delta" {
  type = number
  default = 200
}