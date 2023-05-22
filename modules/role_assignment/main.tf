locals {
  role_assignments = flatten([
    for api_permission in var.api_permissions : [
      for required_role in api_permission.required_roles : {
        app_role_id : var.registered_service_principles[api_permission.target_app_name].app_role_ids[required_role]
        principal_object_id : var.registered_service_principles[api_permission.app_name].object_id
        resource_object_id : var.registered_service_principles[api_permission.target_app_name].object_id
      }
    ]
  ])
}

resource "azuread_app_role_assignment" "role_assignment" {
  for_each = {
    for index, role_assignment in local.role_assignments :
    index => role_assignment
  }

  app_role_id         = each.value.app_role_id
  principal_object_id = each.value.principal_object_id
  resource_object_id  = each.value.resource_object_id
}
