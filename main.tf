module "sync" {
  source = "./modules/sync"

  display_name = "Sync"
}

module "source_app" {
  source = "./modules/application"

  display_name  = "Source App"
  redirect_uris = ["http://localhost/auth-response"]
  app_roles     = ["Source Read All", "Source Read Restricted"]
  api_permissions = [{
    app_name       = "Sync"
    required_roles = ["Source Read All", "Source Read Restricted"]
  }]
}

module "target_app" {
  source = "./modules/application"

  display_name  = "Target App"
  redirect_uris = ["http://localhost/auth-response"]
  app_roles     = ["Target Write All"]
  api_permissions = [{
    app_name       = "Sync"
    required_roles = ["Target Write All"]
  }]
}
