locals {
  app_roles = toset(flatten([
    for app in var.apps : [
      for app_role in app.app_roles :
        app_role
    ]
  ]))
}

resource "random_uuid" "app_role_id" {
  for_each = local.app_roles
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
  for_each = {
    for index, app in var.apps:
    index => app
  }

  display_name = each.value.display_name

  single_page_application {
    redirect_uris = each.value.redirect_uris
  }

  dynamic "app_role" {
    for_each = each.value.app_roles
    iterator = app_role

    content {
      allowed_member_types = ["Application"]
      description          = app_role.value
      display_name         = app_role.value
      id                   = local.app_role_ids[app_role.value]
      value                = replace(lower(app_role.value), ".", "-")
    }
  }
}

resource "azuread_service_principal" "service_principle" {
  for_each = azuread_application.application
  
  application_id               = each.value.application_id
  app_role_assignment_required = false
  use_existing = true
}
