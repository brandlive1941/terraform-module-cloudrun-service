variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
}

variable "name_prefix" {
  description = "cloud run service name prefix"
  type        = string
}

variable "image" {
  description = "docker image name"
  type        = string
}

variable "service_account" {
  description = "OPTIONAL: service account to run the container as"
  type        = optional(string)
}

variable "env_vars" {
  description = "Environment variables to set in the container"
  type = map(object({
    source  = string # secret manager secret name
    version = string # secret manager secret version
  }))
  default = {}
}

variable "volumes" {
  description = "Mount a secret manager secret file as a volume in the container"
  type = list(object({
    name   = string
    path   = string
    source = string
  }))
  default = []
}
