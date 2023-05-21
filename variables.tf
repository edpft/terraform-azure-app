variable client_id {
    type      = string
    nullable  = false
}

variable client_certificate_path {
    type      = string
    nullable  = false
}

variable client_certificate_password {
    type      = string
    nullable  = false
    sensitive = true
}

variable tenant_id {
    type      = string
    nullable  = false
}
