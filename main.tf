module "app" {
  source = "./modules/application"

  apps = [
    {
      display_name = "Sync"
    },
    {
      display_name  = "Source App"
      redirect_uris = ["http://localhost/auth-response"]
      app_roles     = ["Source.Read.All", "Source.Read.Restricted"]
    },
    {
      display_name  = "Target App"
      redirect_uris = ["http://localhost/auth-response"]
      app_roles     = ["Target.Write.All"]
    }
  ]

}

module "role_assignment" {
  source = "./modules/role_assignment"
  depends_on = [ module.app ]

  registered_service_principles = module.app.registered_service_principles

  api_permissions = [
    {
      app_name        = "Sync"
      target_app_name = "Source App"
      required_roles  = ["Source.Read.All", "Source.Read.Restricted"]
    },
    {
      app_name        = "Sync"
      target_app_name = "Target App"
      required_roles  = ["Target.Write.All"]

    }
  ]

}
