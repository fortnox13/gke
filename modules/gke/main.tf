/*
  This module intended to create regional GKE cluster with:
  - non-default node pool
  - workload identity
  - autoscaling
  https://cloud.google.com/kubernetes-engine
  https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools
  https://cloud.google.com/blog/products/containers-kubernetes/introducing-workload-identity-better-authentication-for-your-gke-applications
  https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler
  https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-autoscaler

  In addition to it this module will create:
  - GCP IAM service account for GKE cluster
  - subnetwork with custom CIDRs for pods and services
  The concept of GCP IAM SA could be found here:
  https://cloud.google.com/iam/docs/service-accounts
*/
locals {
  gke_nodes_sa = "${var.cluster_name}-nodes-sa"
  subnetwork   = "${var.cluster_name}-subnet"
}


resource "google_service_account" "gke_nodes_sa" {
  project      = var.gcp_project_id
  account_id   = local.gke_nodes_sa
  display_name = "Service Account that belongs to the GKE node pool"
}

resource "google_project_iam_member" "gke_nodes_sa_bindings" {
  for_each = toset([
    "roles/storage.objectViewer",
    "roles/source.reader"
  ])

  project = var.gcp_project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes_sa.email}"
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = local.subnetwork
  ip_cidr_range = var.primary_ip_cidr_range
  project       = var.gcp_project_id
  region        = var.cluster_region
  network       = var.network

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.secondary_ip_range_svc
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.secondary_ip_range_pods
  }
}

resource "google_container_cluster" "cluster" {
  provider = google-beta

  project        = var.gcp_project_id
  name           = var.cluster_name
  location       = var.cluster_location
  node_locations = var.cluster_node_locations

  network    = var.network
  subnetwork = google_compute_subnetwork.subnetwork.id

  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnetwork.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.subnetwork.secondary_ip_range.1.range_name
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_enabled ? [1] : []
    content {
      identity_namespace = "${var.gcp_project_id}.svc.id.goog"
    }
  }

  addons_config {
    network_policy_config {
      disabled = false
    }

    istio_config {
      disabled = !var.istio_config
    }
  }

  network_policy {
    enabled = true
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master_authorized_network
      display_name = "master authorized networks config"
    }
  }

  cluster_autoscaling {
    enabled = var.cluster_autoscaling

    dynamic "resource_limits" {
      for_each = var.cluster_autoscaling ? [1] : []
      content {
        resource_type = "memory"
        minimum       = var.memory_min
        maximum       = var.memory_max

      }
    }

    dynamic "resource_limits" {
      for_each = var.cluster_autoscaling ? [1] : []
      content {
        resource_type = "cpu"
        minimum       = var.cpu_min
        maximum       = var.cpu_max
      }
    }
  }

  remove_default_node_pool  = true
  initial_node_count        = var.initial_node_count
  default_max_pods_per_node = var.default_max_pods_per_node

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }
}

resource "google_container_node_pool" "cluster_node_pool" {
  project    = var.gcp_project_id
  name       = "${var.cluster_name}-node-pool"
  location   = var.cluster_location
  cluster    = google_container_cluster.cluster.name
  node_count = var.initial_node_count

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = 30

    dynamic "workload_metadata_config" {
      for_each = var.workload_identity_enabled ? [1] : []
      content {
        node_metadata = "GKE_METADATA_SERVER"
      }
    }

    service_account = google_service_account.gke_nodes_sa.email
    # The set of Google API scopes to be made available on all of the node VMs under the provided service account.
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/source.full_control"
    ]
  }
}