provider "azurerm" {}

variable "location" {
  default = "UK South"
}

variable "product" {
  default = "inspec"
}

variable "random_name" {}

variable "env" {
  default = "int"
}

data "terraform_remote_state" "core_sandbox_infrastructure" {
  backend = "azure"

  config {
    resource_group_name  = "contino-moj-tf-state"
    storage_account_name = "continomojtfstate"
    container_name       = "contino-moj-tfstate-container"
    key                  = "sandbox-core-infra/dev/terraform.tfstate"
    subnetid             = "sandbox-core-infra-vnet"
  }
}

module "cache" {
  source              = "../../../../../"
  product             = "${var.random_name}-cache"

  cachename = "${var.random_name}-${var.env}"
  location  = "${var.location}"
  subnetid  = "${data.terraform_remote_state.core_sandbox_infrastructure.config.subnetid}"
  env       = "${var.env}"

}

output "random_name" {
  value = "${var.random_name}"
}
