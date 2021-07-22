/*
  This module intended to create all resources that must be created to do the load balancing
  for the multi regional cluster created in the gke module.
  The main concepts of the GCP Global HTTP(S) Load Balancer you could find here:
  https://cloud.google.com/load-balancing/docs/https
  https://cloud.google.com/load-balancing/docs/https/setting-up-https
  https://cloud.google.com/load-balancing/docs/https/setting-up-https
  or even here:
  https://registry.terraform.io/modules/GoogleCloudPlatform/lb-http/google/latest/examples/https-gke
*/

resource "time_sleep" "wait" {
  # We need to wait up to 10 minutes that all NEGs that were created in k8s module could be
  # available for adding them to the backend service
  create_duration = "10m"
}

data "google_compute_network_endpoint_group" "network_endpoint_group" {
  for_each = var.zones

  name    = var.lb_neg_name
  project = var.gcp_project_id
  zone    = each.value

  depends_on = [time_sleep.wait]
}

resource "google_compute_global_address" "global_address" {
  # The main concepts regarding the ability to reserve external IP address that would be
  # used as an entry point for the LB could be found here:
  # https://cloud.google.com/compute/docs/ip-addresses
  name    = "${var.service_name}-global-ip"
  project = var.gcp_project_id
}

resource "google_compute_health_check" "health_check" {
  # The main concept regarding the GCP health check could be found here:
  # https://cloud.google.com/load-balancing/docs/health-check-concepts
  provider = google-beta
  project  = var.gcp_project_id
  name     = "${var.service_name}-health-check"

  https_health_check {
    port_specification = "USE_SERVING_PORT"
  }

  log_config {
    enable = true
  }
}

resource "google_compute_backend_service" "backend_service" {
  # The main concept regarding the GCP backend service could be found here:
  # https://cloud.google.com/load-balancing/docs/backend-service
  name       = "${var.service_name}-backend-service"
  project    = var.gcp_project_id
  enable_cdn = true

  lifecycle {
    ignore_changes = all
  }

  health_checks = [google_compute_health_check.health_check.id]

  session_affinity = "CLIENT_IP"
  protocol         = "HTTPS"
  timeout_sec      = 60

  log_config {
    enable = true
  }

  dynamic "backend" {
    for_each = var.zones

    content {
      balancing_mode = "RATE"
      max_rate       = 1
      group          = data.google_compute_network_endpoint_group.network_endpoint_group[backend.value].id
    }
  }
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  # The main concept regarding the GCP forwarding rule could be found here:
  # https://cloud.google.com/load-balancing/docs/forwarding-rule-concepts
  # https://cloud.google.com/load-balancing/docs/using-forwarding-rules
  provider              = google-beta
  project               = var.gcp_project_id
  name                  = "${var.service_name}globalrule"
  port_range            = var.lb_exposed_port
  target                = google_compute_target_https_proxy.target_https_proxy.id
  ip_address            = google_compute_global_address.global_address.address
  load_balancing_scheme = ""

  lifecycle {
    ignore_changes = all
  }
}

resource "google_compute_ssl_certificate" "ssl_certificate" {
  # The main concept regarding the GCP ssl certificate could be found here:
  # https://cloud.google.com/load-balancing/docs/ssl-certificates
  #
  name        = "${var.service_name}-certificate"
  project     = var.gcp_project_id
  private_key = file(var.private_key)
  certificate = file(var.certificate)
}

resource "google_compute_target_https_proxy" "target_https_proxy" {
  # The main concept regarding the GCP target https proxy could be found here:
  # https://cloud.google.com/load-balancing/docs/target-proxies
  provider         = google-beta
  project          = var.gcp_project_id
  name             = "${var.service_name}-target-https-proxy"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.ssl_certificate.id]
}

resource "google_compute_url_map" "url_map" {
  # The main concept regarding the GCP forwarding rule could be found here:
  # https://cloud.google.com/load-balancing/docs/url-map-concepts
  # https://cloud.google.com/load-balancing/docs/url-map
  provider        = google-beta
  project         = var.gcp_project_id
  name            = "${var.service_name}-url-map"
  default_service = google_compute_backend_service.backend_service.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend_service.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backend_service.id
    }
  }
}