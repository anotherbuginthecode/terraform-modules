variable "repository_name" {
  type = string
  description = "The name of your repository"
}

variable "description" {
  type = string
  description = "A brief description of your repository"
  default = ""
}

variable "visibility" {
  type = string
  description = "Set your repository as public or private (default: private)"

  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "Valid values for var: visibility are (public, private)."
  } 
}

variable "branches" {
  type = list
  description = "Initialize your repository with additional branches"
  default = []
}