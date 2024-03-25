locals {
  service_account_name = var.service_account == "" ? "${var.name_prefix}-cr-sa" : var.service_account
  service_account      = module.service_account[0].email == null ? data.google_service_account.service_account[0].email : module.service_account[0].email
  services = {
    for region in var.regions : region => {
      name           = "${var.name_prefix}-cr"
      location       = region
      container_port = var.container_port
      env            = var.env_vars
    }
  }
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.registry_location
  repository_id = var.artifact_repo_name
  description   = "${var.artifact_repo_name} ${var.github_org}/${var.repository}"
  format        = "DOCKER"
}

module "service_account" {
  count = var.service_account == "" ? 1 : 0

  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.2.2"
  project_id = var.project_id
  names      = [local.service_account_name]
}

data "google_service_account" "service_account" {
  count = var.service_account == "" ? 0 : 1

  account_id = var.service_account
}

resource "google_cloud_run_v2_service" "default" {
  for_each = local.services
  provider = google-beta

  name     = each.value["name"]
  location = each.value["location"]
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.registry_location}-docker.pkg.dev/${var.project_id}/${var.image}"
      ports {
        container_port = each.value["container_port"]
      }
      dynamic "env" {
        for_each = each.value["env"]
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value["source"]
              version = env.value["version"]
            }
          }
        }
      }
    }
    dynamic "volumes" {
      for_each = var.volumes
      iterator = volume

      content {
        name = volume.value["name"]
        secret {
          secret = volume.value["source"]
          items {
            version = "latest"
            path    = volume.value["path"]
            mode    = 0 # use default 0444
          }
        }
      }
    }
    service_account = local.service_account
  }
  lifecycle {
    ignore_changes = [
      annotations,
      client_version,
      client,
      labels,
      template[0].annotations,
      template[0].labels,
    ]
  }
}

