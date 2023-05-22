output "registered_apps" {
  value = module.app.registered_apps
}

output "registered_service_principles" {
  value = module.app.registered_service_principles
}

output "assigned_roles" {
  value = module.role_assignment.assigned_roles
}