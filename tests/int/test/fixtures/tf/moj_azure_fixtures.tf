provider "azurerm" {}

variable "location" {
  default = "UK South"
}

variable "product" {
  default = "inspect"
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
    subnetid             = "sandbox-core-infra-subnet-0-dev"
  }
}

output "random_name" {
  value = "${var.random_name}"
}

resource "azurerm_resource_group" "cache-resourcegroup" {
  name     = "${var.random_name}-cache-${var.env}"
  location = "${var.location}"
}

data "template_file" "redistemplate" {
  template = "${file("${path.module}/../../templates/redis-paas.json")}"
}

resource "azurerm_template_deployment" "redis-paas" {
  template_body       = "${data.template_file.redistemplate.rendered}"
  name                = "${var.random_name}-${var.env}"
  resource_group_name = "${azurerm_resource_group.cache-resourcegroup.name}"
  deployment_mode     = "Incremental"

  parameters = {
    cachename = "${var.random_name}-${var.env}"
    location  = "${azurerm_resource_group.cache-resourcegroup.location}"
    subnetid  = "${data.terraform_remote_state.core_sandbox_infrastructure.config.subnetid}"
    env       = "${var.env}"
  }
}
