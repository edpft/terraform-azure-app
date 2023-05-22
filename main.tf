module "sync" {
  source = "./modules/sync"

  display_name = "Sync"
}

module "source_app" {
  source = "./modules/application"

  display_name  = "Source App"
  redirect_uris = ["http://localhost/auth-response"]
  app_roles     = ["Source Read All", "Source Read Restricted"]
}

module "target_app" {
  source = "./modules/application"

  display_name  = "Target App"
  redirect_uris = ["http://localhost/auth-response"]
  app_roles     = ["Target Write All"]
}

module "role_assignment" {
  source = "./modules/role_assignment"

  api_permissions = [
    {
      app_name        = "Sync"
      target_app_name = "Source App"
      required_roles  = ["Source Read All", "Source Read Restricted"]
    },
    {
      app_name        = "Sync"
      target_app_name = "Target App"
      required_roles  = ["Target Write All"]

    }
  ]

}
