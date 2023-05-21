data "azuread_application" "requiring_applications" {
  count = length(var.api_permissions)

  display_name = var.api_permissions[count.index].app_name
}

resource "random_uuid" "app_role_id" {
  for_each = var.app_roles
  keepers = {
    "key" = each.value
  }
}

locals {
  app_role_ids = tomap({
    for app_role, app_role_id in random_uuid.app_role_id :
    app_role => app_role_id.result
  })
}

resource "azuread_application" "application" {
  display_name = var.display_name

  single_page_application {
    redirect_uris = var.redirect_uris
  }

  dynamic "app_role" {
    for_each = var.app_roles
    iterator = app_role

    content {
      allowed_member_types = ["Application"]
      description          = app_role.value
      display_name         = app_role.value
      id                   = lookup(local.app_role_ids, app_role.value)
      value                = replace(lower(app_role.value), " ", "-")
    }
  }

  dynamic "required_resource_access" {
    for_each = data.azuread_application.requiring_applications
    iterator = requiring_application

    content {
      resource_app_id = requiring_application.value.application_id

      dynamic "resource_access" {
        for_each = flatten([for api_permission in var.api_permissions : api_permission.required_roles if api_permission.app_name == requiring_application.value.display_name])
        iterator = required_role

        content {
          id   = lookup(local.app_role_ids, required_role.value)
          type = "Role"
        }
      }
    }
  }
}

resource "azuread_service_principal" "application_service_principle" {
  application_id               = azuread_application.application.application_id
  app_role_assignment_required = false
}
