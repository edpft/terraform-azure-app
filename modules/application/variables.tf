variable "display_name" {
  type = string
}

variable "redirect_uris" {
  type = set(string)
}

variable "app_roles" {
  type = set(string)
}
