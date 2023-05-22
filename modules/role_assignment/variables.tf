variable "api_permissions" {
  type = list(object({
    app_name        = string
    target_app_name = string
    required_roles  = set(string)
  }))
  default = []
}
