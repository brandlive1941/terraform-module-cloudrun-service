variable "project_id" {
  description = "project id"
  type        = string
}

variable "regions" {
  description = "regions to deploy the cloud run service to"
  type        = list(string)
}

variable "registry_location" {
  description = "image location"
  type        = string
  default     = "us"
}

variable "name_prefix" {
  description = "cloud run service name prefix"
  type        = string
}

variable "image" {
  description = "docker image name"
  type        = string
}

variable "container_port" {
  description = "container port"
  type        = number
  default     = 8080
}

variable "service_account" {
  description = "OPTIONAL: service account to run the container as"
  type        = string
  default     = ""
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
