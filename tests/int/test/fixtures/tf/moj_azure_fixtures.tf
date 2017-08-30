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
    subnetid             = "${azurerm_subnet.subnet.id}"
  }
}

output "random_name" {
  value = "${var.random_name}"
}

resource "azurerm_resource_group" "cache-resourcegroup" {
  name     = "${var.random_name}-cache-${var.env}"
  location = "${var.location}"
}

# Create the virtual network for the machines
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.random_name}-vnet-${var.env}"
  address_space       = ["10.1.1.0/24"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.cache-resourcegroup.name}"
}

# Create the subnet
resource "azurerm_subnet" "subnet" {
  name                 = "Inspec-Subnet"
  resource_group_name  = "${azurerm_resource_group.cache-resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.1.1.0/24"
}

data "template_file" "redistemplate" {
  template = "${file("${path.module}/../../../../../templates/redis-paas.json")}"
}

resource "azurerm_template_deployment" "redis-paas" {
  template_body       = "${data.template_file.redistemplate.rendered}"
  name                = "${var.random_name}-${var.env}"
  resource_group_name = "${azurerm_resource_group.cache-resourcegroup.name}"
  deployment_mode     = "Incremental"

  parameters = {
    cachename = "${var.random_name}-${var.env}"
    location  = "${azurerm_resource_group.cache-resourcegroup.location}"
    subnetid  = "${azurerm_subnet.subnet.id}"
    env       = "${var.env}"
  }
}
