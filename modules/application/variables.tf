# variable "display_name" {
#   type = string
# }

# variable "redirect_uris" {
#   type = set(string)
# }

# variable "app_roles" {
#   type = set(string)
# }

variable "apps" {
  type = list(object({
    display_name = string
    redirect_uris = optional(set(string), [])
    app_roles = optional(set(string), [])
  }))
}