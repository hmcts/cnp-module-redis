resource "azurerm_resource_group" "cache-resourcegroup" {
  name     = "${var.product}-cache-${var.env}"
  location = "${var.location}"

  tags = "${merge(var.common_tags,
    map("lastUpdated", "${timestamp()}")
    )}"
}

data "template_file" "redistemplate" {
  template = "${file("${path.module}/templates/redis-paas.json")}"
}

resource "azurerm_template_deployment" "redis-paas" {
  template_body       = "${data.template_file.redistemplate.rendered}"
  name                = "${var.product}-${var.env}"
  resource_group_name = "${azurerm_resource_group.cache-resourcegroup.name}"
  deployment_mode     = "Incremental"

  parameters = {
    cachename = "${var.product}-${var.env}"
    location  = "${azurerm_resource_group.cache-resourcegroup.location}"
    subnetid  = "${var.subnetid}"
    env       = "${var.env}"
    teamName  = "${lookup(var.common_tags, "Team Name")}"
  }
}
