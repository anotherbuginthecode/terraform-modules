variable "name" {
  type = string
  description = "(Required) Name of the repository."
}

variable "image_tag_mutability" {
  type = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
}

variable "tags" {
  type = map
  description = "(Optional) A map of tags to assign to the resource. "
}

variable "policy" {
  type = string
  description = "(Optional) Lifecycle policy of ECR Images."

}