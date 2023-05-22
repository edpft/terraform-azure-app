locals {
  app_names        = toset([for api_permission in var.api_permissions : api_permission.app_name])
  target_app_names = toset([for api_permission in var.api_permissions : api_permission.target_app_name])

}

data "azuread_application" "application" {
  for_each = local.app_names

  display_name = each.value
}

data "azuread_application" "target_application" {
  for_each = local.target_app_names

  display_name = each.value
}

data "azuread_service_principal" "service_principal" {
  for_each = {
    for index, app in data.azuread_application.application :
    index => app.application_id
  }

  application_id = each.value
}

data "azuread_service_principal" "target_service_principal" {
  for_each = {
    for index, app in data.azuread_application.target_application :
    index => app.application_id
  }

  application_id = each.value
}

locals {
  service_principals = {
    for service_principal in data.azuread_service_principal.service_principal :
    service_principal.display_name => service_principal.object_id
  }
  targets = {
    for service_principal in data.azuread_service_principal.target_service_principal :
    service_principal.display_name => {
      object_id    = service_principal.object_id
      app_role_ids = service_principal.app_role_ids
    }
  }
  role_assignments = flatten([
    for api_permission in var.api_permissions : [
      for required_role in api_permission.required_roles : {
        app_role_id : local.targets[api_permission.target_app_name].app_role_ids[replace(upper(required_role), " ", ".")]
        principal_object_id : local.service_principals[api_permission.app_name]
        resource_object_id : local.targets[api_permission.target_app_name].object_id
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
