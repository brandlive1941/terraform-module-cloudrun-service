# terraform-module-cloudbuild-artifact
create cloudbuild triggers and artifact registry repository in gcp

A terraform module to provide a cloudbuild trigger and artifact registry repository

Module Input Variables
----------------------

- `project_id` - GCP Project ID
- `region` - Region
- `name-prefix` - Cloud Run Service/Account nomenclature
- `image` - Docker Image Name
- `service_account` - Optional: Service Account to use instead of creating one
- `env_vars` - Optional: Docker Environment Variables mounted Secret Manager Secrets
- `volumes` - Optional: Volume Mounted Secret Manager Secrets

Usage
-----

```hcl
module "service-name-cloudrun" {
  source = "github.com/brandlive1941/terraform-gcp/modules/terraform-modules-cloudrun@?ref=v1.0.1"

  project_id          = var.project_id
  region              = var.region
  name_prefix         = local.name_prefix
  image               = local.image
  env_vars            = var.env_vars
}
```

Outputs
=======


Development
=======

Thise repo uses `cz`[https://github.com/semantic-release/commit-analyzer/] to manage semantic versioning. Please use the following set of commands to initialize your development environment and commit changes:

```
asdf install
npm install
npm install -g commitizen
```
**MAKE SOME CHANGES**
```
git checkout -b BRANCH_NAME
git add *
git cz
git push origin BRANCH_NAME
```

Authors
=======

drew.mercer@brandlive.com
