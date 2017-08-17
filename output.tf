output "host_name" {
  value = "${azurerm_template_deployment.redis-paas.name}.redis.cache.windows.net"
}

output "redis_port" {
  value = "${var.redis_port}"
}
