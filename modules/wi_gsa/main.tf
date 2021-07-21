/*
  This module creates all needed resource to configure GKE workload identity.
  Exactly this module will do all needed from the GCP IAM side.
  The details could be found here:
  https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/submodules/workload-identity
  https://cloud.google.com/blog/products/containers-kubernetes/introducing-workload-identity-better-authentication-for-your-gke-applications
  https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
*/

locals {
  k8s_sa_gcp_derived_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.name}]"
  gcp_sa_email            = google_service_account.cluster_service_account.email
}

resource "google_service_account" "cluster_service_account" {
  # GCP service account ids must be < 30 chars matching regex ^[a-z](?:[-a-z0-9]{4,28}[a-z0-9])$
  # KSA do not have this naming restriction.
  account_id   = substr(var.name, 0, 30)
  display_name = substr("GCP SA bound to K8S SA ${var.k8s_given_name}", 0, 100)
  project      = var.project_id
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.cluster_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}


resource "google_project_iam_member" "workload_identity_sa_bindings" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}