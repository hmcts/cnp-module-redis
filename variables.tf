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
  type = map(string)
}

variable "minimum_tls_version" {
  type    = string
  default = "1.2"
}

variable "capacity" {
  default = "1"
}

variable "maxmemory_policy" {
  type    = string
  default = "volatile-lru"
}

variable "maxmemory_reserved" {
  default = "200"
}

variable "maxfragmentationmemory_reserved" {
  default = "300"
}

variable "maxmemory_delta" {
  default = "200"
}