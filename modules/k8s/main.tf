/*
  This module intended to create all K8s objects that MUST be created via the terraform.
  1. Namespaces should be created before the Workload Identity module to be able to annotate
  K8s service accounts.
  2. Devops secret COULD be created just for simplify the Ping Identity deployments. It's
  optional component.
  3. K8s service MUST be created beforehand the Load Balancer because the NEGs that should be
  used for LB backend service creation MUST be already exist to be able to be added to the
  appropriate terraform data structure.
*/

locals {
  # Variable that would be used for K8s service creation.
  # Take a look on these references to clarify the concept:
  # https://cloud.google.com/load-balancing/docs/negs
  # https://cloud.google.com/kubernetes-engine/docs/how-to/standalone-neg#standalone_negs
  # https://medium.com/google-cloud/container-load-balancing-on-google-kubernetes-engine-gke-4cbfaa80a6f6
  annotation = "{\"exposed_ports\": {\"${var.lb_exposed_port}\": {\"name\": \"${var.lb_neg_name}\"}}}"
}

resource "kubernetes_namespace" "k8s_namespace" {
  for_each = var.namespaces

  metadata {
    labels = {
      cluster = var.cluster_name
    }

    annotations = {
      finalizers = null
    }

    name = each.value
  }
}

resource "kubernetes_secret" "devops-secret" {
  for_each = var.namespaces

  metadata {
    namespace = each.value
    name      = "devops-secret"
    annotations = {
      "ping-devops.app-version" = "v0.7.3"
      "ping-devops.user"        = var.ping_devops_user_plain
    }
  }

  binary_data = {
    "PING_IDENTITY_ACCEPT_EULA" = "WUVT"
    "PING_IDENTITY_DEVOPS_KEY"  = var.ping_devops_key_encrypted
    "PING_IDENTITY_DEVOPS_USER" = var.ping_devops_user_encrypted
  }

  type = "Opaque"

  depends_on = [kubernetes_namespace.k8s_namespace]
}

resource "kubernetes_service" "kubernetes_service" {
  for_each = toset([for i in var.svc_namespaces : i if var.svc_enabled])

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

  metadata {
    namespace = each.value
    name      = "${var.svc_instance}-pingdataconsole-https"

    annotations = {
      "cloud.google.com/neg" = local.annotation
      "meta.helm.sh/release-name" : var.svc_instance
      "meta.helm.sh/release-namespace" : each.value
      "app.kubernetes.io/instance" : var.svc_instance
      "app.kubernetes.io/managed-by" : "Helm"
      "app.kubernetes.io/name" : "pingdataconsole"
      "helm.sh/chart" : "ping-devops-0.6.3"
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/instance" : var.svc_instance
      "app.kubernetes.io/name" : "pingdataconsole"
    }

    session_affinity = "ClientIP"

    port {
      name        = "pingfederate-https"
      protocol    = "TCP"
      port        = 443
      target_port = 8443
    }

    type = "ClusterIP"
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}