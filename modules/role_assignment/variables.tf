variable "registered_service_principles" {
  type = map(object({
    object_id = string
    app_role_ids = map(string)
  }))
}



variable "api_permissions" {
  type = list(object({
    app_name        = string
    target_app_name = string
    required_roles  = set(string)
  }))
  default = []
}
