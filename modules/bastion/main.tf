/*
  This module intended for creation so called bastion host.
  Bastion host should be used for accessing and managing the
  GKE clusters that would be created via gke module.
  The basic concept of bastion hosts could be found here:
  https://en.wikipedia.org/wiki/Bastion_host
  The basic how-to could be found here:
  https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest/examples/safer_cluster_iap_bastion
  here:
  https://medium.com/google-cloud/gke-private-cluster-with-a-bastion-host-5480b44793a7
  and here:
  https://cloud.google.com/solutions/connecting-securely#bastion
*/

locals {
  # The GCP IAM service account name that would be used for the bastion host:
  bastion_sa = "${var.cluster_name}-bastion-sa"
  # The subnetwork name for the bastion host:
  subnetwork_name = "${var.cluster_name}-bastion-subnet"
  # The VM name:
  compute_instance_name = "${var.cluster_name}-bastion-host"
}


resource "google_service_account" "bastion_sa" {
  project      = var.gcp_project_id
  account_id   = local.bastion_sa
  display_name = "Bastion host Service Account"
}

resource "google_project_iam_member" "bastion_sa_iam" {
  for_each = toset([
    "roles/container.admin",
    "roles/container.clusterAdmin"
  ])

  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = local.subnetwork_name
  ip_cidr_range = var.primary_ip_cidr_range
  project       = var.gcp_project_id
  region        = var.gcp_region
  network       = var.network
}

resource "google_compute_instance" "bastion" {
  project      = var.gcp_project_id
  name         = local.compute_instance_name
  machine_type = var.machine_type
  zone         = var.gcp_zone

  tags = ["bastion"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnetwork.self_link
  }

  # Next script should configure the bastion host: install all apps, do all configs etc
  metadata_startup_script = file("./scripts/bastion_startup_script.sh")

  service_account {
    email  = google_service_account.bastion_sa.email
    scopes = ["cloud-platform"]
  }
}