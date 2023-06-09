output "registered_apps" {
  value = [
    for index, application in azuread_application.application :
      application.display_name
  ]
}

output "registered_service_principles" {
  value = {
    for index, service_principle in azuread_service_principal.service_principle :
      service_principle.display_name => {
        "object_id" = service_principle.object_id
        "app_role_ids" = service_principle.app_role_ids
      }
  }
}

