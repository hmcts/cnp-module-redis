variable "product" {
  type = "string"
}

variable "location" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "subnetid" {
  type = "string"
}

variable "redis_port" {
  type    = "string"
  default = "6379"
}
