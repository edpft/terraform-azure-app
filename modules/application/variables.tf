variable "display_name" {
  type = string
}

variable "redirect_uris" {
  type = set(string)
}

variable "app_roles" {
  type = set(string)
}

variable "api_permissions" {
  type = list(object({
    app_name       = string
    required_roles = set(string)
  }))
  default = []
}
