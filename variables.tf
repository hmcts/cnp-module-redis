variable "product" {
  type = "string"
}

variable "location" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "redis_port" {
  type    = "string"
  default = "6379"
}

variable "subnetid" {
  type    = "string"
  default = "${data.terraform_remote_state.core_apps_infrastructure.subnet_ids[2]}"
}
