variable "apps" {
  type = list(object({
    display_name = string
    redirect_uris = optional(set(string), [])
    app_roles = optional(set(string), [])
  }))
}