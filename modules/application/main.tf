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
      value                = replace(upper(app_role.value), " ", ".")
    }
  }
}

resource "azuread_service_principal" "service_principle" {
  application_id               = azuread_application.application.application_id
  app_role_assignment_required = false
}
