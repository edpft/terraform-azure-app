output "assigned_roles" {
  value = {
    for index, role_assignment in azuread_app_role_assignment.role_assignment :
      role_assignment.principal_display_name => tomap({
        (role_assignment.resource_display_name) = role_assignment.app_role_id
      })...
  }
}