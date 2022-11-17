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

variable "cors_configuration" {
  type = map(string)
  default = {}
}

variable "stage" {
  type = string
  default = ""
}

variable "enable_cognito_authorizer" {
  type = bool
  default = false
}

variable "authorizer_result_ttl_in_seconds" {
  type = number
  default = 300
}

variable "cognito_client_id" {
  type = string
  default = null
}

variable "cognito_region" {
  type = string
  default = null
}

variable "cognito_user_pool_id" {
  type = string
  default = null
}