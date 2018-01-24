output "host_name" {
  value = "${azurerm_template_deployment.redis-paas.outputs["hostName"]}"
}

output "access_key" {
  value = "${azurerm_template_deployment.redis-paas.outputs["accessKey"]}"
}

output "redis_port" {
  value = "${azurerm_template_deployment.redis-paas.outputs["sslPort"]}"
}
