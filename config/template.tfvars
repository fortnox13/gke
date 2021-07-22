#--------------------------------------------------------------
# General
#--------------------------------------------------------------
# A customizable unique identifier for your project:
gcp_project_id = ""
# The next 3 variables should be provided through env variables with TF_VAR_ prefix.
# Email in clean text for devops user that have the working license key:
ping_devops_user_plain = ""
# License key that was encrypted with base64:
ping_devops_key_encrypted = ""
# The devops user email that was encrypted with base64:
ping_devops_user_encrypted = ""

#--------------------------------------------------------------
# Network
#--------------------------------------------------------------
# The VPC network name
network_name = ""

# CIDR for the IPs that would be assigned to the worker nodes:
network_gke-1_primary_ip_cidr_range = ""
network_gke-2_primary_ip_cidr_range = ""
# CIDR for the IPs that would be assigned to the master nodes:
network_gke-1_master_ipv4_cidr_block = ""
network_gke-2_master_ipv4_cidr_block = ""
# CIDR for the IPs that would be assigned to the K8s services:
network_gke-1_secondary_ip_range_svc = ""
network_gke-2_secondary_ip_range_svc = ""
# CIDR for the IPs that would be assigned to the K8s pods:
network_gke-1_secondary_ip_range_pods = ""
network_gke-2_secondary_ip_range_pods = ""

#--------------------------------------------------------------
# GKE
#--------------------------------------------------------------
# The GKE cluster name:
cluster_gke-1_name = ""
cluster_gke-2_name = ""
# The GKE cluster location (zone or region, based on the cluster type):
cluster_gke-1_location = ""
cluster_gke-2_location = ""
# The GKE cluster region:
cluster_gke-1_region = ""
cluster_gke-2_region = ""
# The locations (zones) for the cluster' nodes:
cluster_gke-1_node_locations = []
cluster_gke-2_node_locations = []

# Whether enable or not the GKE autoscaling feature
# https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-autoscaler
cluster_autoscaling = true
# With GKE, you can create a cluster tailored to the availability requirements
# of your workload and your budget. The types of available clusters include: zonal (single-zone or multi-zonal)
# and regional.
# https://cloud.google.com/kubernetes-engine/docs/concepts/types-of-clusters#availability
cluster_type = "regional"
# All VMs are categorized by machine family. Every machine family has predefined machine shapes that have
# a specific vCPU to memory ratio that fits a variety of workload needs.
# https://cloud.google.com/compute/docs/machine-types
cluster_machine_type = "n1-standard-1"
# Default maximum number of pods that could bu scheduled on a worker node:
cluster_default_max_pods_per_node = 30
# Whether enable or not the GKE Workload Identity feature
# https://cloud.google.com/blog/products/containers-kubernetes/introducing-workload-identity-better-authentication-for-your-gke-applications
cluster_workload_identity_enabled = true
# The namespaces that should be created and configured to use GKE Workload Identity feature:
cluster_k8s_namespaces = []
# Whether enable or not the GKE istio plugin.
# https://cloud.google.com/istio/docs/istio-on-gke/overview
cluster_istio_config = false
# By default, tools like kubectl communicate with the control plane on its public endpoint.
# You can control access to this endpoint using authorized networks or you can disable access to the public endpoint.
# https://cloud.google.com/kubernetes-engine/docs/concepts/private-cluster-concept#endpoints_in_private_clusters
cluster_master_authorized_network = "0.0.0.0/0"

# Minimum and maximum amount of the resources in the cluster.
# https://cloud.google.com/compute/docs/nodes/autoscaling-node-groups
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#resource_type
cluster_initial_node_count = 1
cluster_cpu_min            = 3
cluster_cpu_max            = 15
cluster_memory_min         = 8
cluster_memory_max         = 40
cluster_min_node_count     = 1
cluster_max_node_count     = 5
#--------------------------------------------------------------
# Workload Identity
#--------------------------------------------------------------
# This variable with map type should have next key variables:
# name - the GCP (and K8s, in case if use_existing_k8s_sa set to false) service accounts
# namespace - the K8s namespace where K8s objects resides
# roles - the GCP IAM roles that should be assigned to the GCP SA
# use_existing_k8s_sa = whether to use or not existing K8s SAs
# annotate_k8s_sa - whether to annotate or not existing K8s SAs
# k8s_sa_name - the K8s existing account to be annotates
wi_gke-1_set = [
  {
    name                = "gke-1-storage-sa"
    namespace           = "gke-1"
    roles               = "roles/storage.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-1-compute-sa"
    namespace           = "gke-1"
    roles               = "roles/compute.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-1-dns-sa"
    namespace           = "gke-1"
    roles               = "roles/dns.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  }
]

wi_gke-2_set = [
  {
    name                = "gke-2-storage-sa"
    namespace           = "gke-2"
    roles               = "roles/storage.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-2-compute-sa"
    namespace           = "gke-2"
    roles               = "roles/compute.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  },
  {
    name                = "gke-2-dns-sa"
    namespace           = "gke-2"
    roles               = "roles/dns.admin"
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = null
  }
]
#--------------------------------------------------------------
# Helm
#--------------------------------------------------------------
# Whether enable or not the helm module to install Ping Identity:
helm_enabled = false
# The Ping Identity repository to be used:
helm_repository = "https://helm.pingidentity.com/"
# The Ping Identity chart to be installed:
helm_chart = "ping-devops"
# The K8s namespace where Ping Identity chart should be installed:
helm_namespace = ""
#--------------------------------------------------------------
# Bastion
#--------------------------------------------------------------
# Whether enable or not the bastion host for a GKE cluster
# https://cloud.google.com/solutions/connecting-securely#bastion
bastion_enabled = false
# IP CIDR to be used to assign the IP addresses to the VM:
bastion_gke-1_ip_cidr_range = "192.168.10.0/24"
bastion_gke-2_ip_cidr_range = "192.168.11.0/24"
# All VMs are categorized by machine family. Every machine family has predefined machine shapes that have
# a specific vCPU to memory ratio that fits a variety of workload needs.
# https://cloud.google.com/compute/docs/machine-types
bastion_machine_type = "n1-standard-1"
#--------------------------------------------------------------
# LB
#--------------------------------------------------------------
# Whether enable or not the Global HTTP(S) Load Balancer
# https://cloud.google.com/load-balancing/docs/https
lb_enabled = false
# The external port that should the LB listen for:
lb_exposed_port = 443
# The Network Endpoint Group that was created when the appropriate K8s service was exposed.
# https://cloud.google.com/load-balancing/docs/https#load_balancing_using_multiple_backend_types
# https://cloud.google.com/load-balancing/docs/negs/zonal-neg-concepts
lb_neg_name = ""
# The service name that should be exposed:
lb_service_name = ""
#--------------------------------------------------------------
# K8s
#--------------------------------------------------------------
# Whether enable or not the k8s module that should create the services to be exposed through the LB:
k8s_enabled = false
# The name of the service instance that should be in the annotation block of the K8s service:
k8s_svc_instance = ""
# Whether enable or not creation of the K8s services within this module:
k8s_svc_enabled = false
# The appropriate namespaces where the K8s services should be created:
k8s_gke-1_svc_namespaces = []
k8s_gke-2_svc_namespaces = []
#--------------------------------------------------------------
# MCS
#--------------------------------------------------------------
# Whether enable or not the MCS GCP feature.
# https://cloud.google.com/blog/products/containers-kubernetes/introducing-gke-multi-cluster-services
mcs_enabled = false