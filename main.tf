locals {
  service_name    = "${var.name_prefix}-${var.region}-cr"
  service_account = var.service_account == "" ? "${var.name_prefix}-cr-sa" : var.service_account
}

module "service_account" {
  count = var.service_account == "" ? 1 : 0

  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.2.2"
  project_id = var.project_id
  names      = [local.service_account]
}

data "google_secret_manager_secret_version" "secrets" {
  for_each = var.env_vars
  secret   = each.value["source"]
}

resource "google_secret_manager_secret_iam_member" "member" {
  for_each  = var.env_vars
  secret_id = data.google_secret_manager_secret_version.secrets[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = local.service_account
}

resource "google_cloud_run_v2_service" "default" {
  provider = google-beta

  name     = local.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.image}"
      dynamic "env" {
        for_each = var.env_vars
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = each.value["source"]
              version = each.value["version"]
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
    service_account = module.service_account.email
  }
}

