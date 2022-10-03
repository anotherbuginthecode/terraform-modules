variable "name" {
  type = string
  description = "(Required) the api gateway's name"
}

variable "description" {
  type = string
  description = "(Optional) describe your api gateway"
  default = ""
}

variable "domain" {
  type = string
  description = "(Optional) your domain name to associate to api gateway"
}