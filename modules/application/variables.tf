variable "display_name" {
  type = string
}

variable "redirect_uris" {
  type = list(string)
}

variable "app_roles" {
  type = list(string)
}

variable "api_permissions" {
  type = list(object({
    app_name       = string
    required_roles = list(string)
  }))
  default = []
}
