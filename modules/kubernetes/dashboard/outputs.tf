output "name" {
  value = var.name
}

output "ports" {
  value = var.ports
}

output "service" {
  value = module.deployment-service.service
}

output "deployment" {
  value = module.deployment-service.deployment
}

output "service_account" {
  value = module.rbac.service_account
}
