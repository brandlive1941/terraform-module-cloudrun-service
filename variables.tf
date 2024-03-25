# It is preferable to create the cloud run service outside of terraform,
# but we still want to control the prequisites for the service via IaC

variable "project_id" {
  description = "project id"
  type        = string
}

variable "regions" {
  description = "regions to deploy the cloud run service, if not regions are provided cloud run creation will be skipped"
  type        = list(string)
  default     = []
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

variable "github_org" {
  description = "github organization"
  type        = string
}

variable "repository" {
  description = "github repository"
  type        = string
}

variable "artifact_repo_name" {
  description = "artifact registry repository name"
  type        = string
}

variable "image" {
  description = "docker image name"
  type        = string
  default     = ""
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
