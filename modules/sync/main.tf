resource "azuread_application" "sync" {
  display_name = var.display_name
}

resource "azuread_service_principal" "sync" {
  application_id = azuread_application.sync.application_id
}
