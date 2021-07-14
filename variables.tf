variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "gcp project id"
}

variable "gcp_regions" {
  type        = set(string)
  default     = []
  description = "Set of gcp regions for network module (Cloud Router and Cloud Nat configuration)"
}

variable "cluster_gke-1_region" {
  type        = string
  default     = ""
  description = "cluster_gke-1_region"
}

variable "cluster_gke-2_region" {
  type        = string
  default     = ""
  description = "cluster_gke-2_region"
}

variable "network_name" {
  type        = string
  default     = ""
  description = "network_name"
}

variable "cluster_gke-1_location" {
  type        = string
  default     = ""
  description = "cluster_gke-1_location"
}

variable "cluster_gke-2_location" {
  type        = string
  default     = ""
  description = "cluster_gke-2_location"
}

variable "ping_devops_user_plain" {
  type        = string
  default     = ""
  description = "ping_devops_user_plain"
}

variable "ping_devops_key_encrypted" {
  type        = string
  default     = ""
  description = "ping_devops_key_encrypted"
}

variable "ping_devops_user_encrypted" {
  type        = string
  default     = ""
  description = "ping_devops_user_encrypted"
}

variable "network_gke-1_primary_ip_cidr_range" {
  type        = string
  default     = ""
  description = "network_gke-1_primary_ip_cidr_range"
}

variable "network_gke-1_master_ipv4_cidr_block" {
  type        = string
  default     = ""
  description = "network_gke-1_master_ipv4_cidr_block"
}

variable "network_gke-1_secondary_ip_range_svc" {
  type        = string
  default     = ""
  description = "network_gke-1_secondary_ip_range_svc"
}

variable "network_gke-1_secondary_ip_range_pods" {
  type        = string
  default     = ""
  description = "network_gke-1_secondary_ip_range_pods"
}

variable "network_gke-2_primary_ip_cidr_range" {
  type        = string
  default     = ""
  description = "network_gke-2_primary_ip_cidr_range"
}

variable "network_gke-2_master_ipv4_cidr_block" {
  type        = string
  default     = ""
  description = "network_gke-2_master_ipv4_cidr_block"
}

variable "network_gke-2_secondary_ip_range_svc" {
  type        = string
  default     = ""
  description = "network_gke-2_secondary_ip_range_svc"
}

variable "network_gke-2_secondary_ip_range_pods" {
  type        = string
  default     = ""
  description = "network_gke-2_secondary_ip_range_pods"
}

variable "cluster_gke-1_name" {
  type        = string
  default     = ""
  description = "cluster_gke-1_name"
}

variable "cluster_gke-2_name" {
  type        = string
  default     = ""
  description = "cluster_gke-2_name"
}

variable "cluster_autoscaling" {
  type        = bool
  default     = false
  description = "cluster_autoscaling"
}

variable "cluster_type" {
  type        = string
  default     = ""
  description = "cluster_type"
}

variable "cluster_machine_type" {
  type        = string
  default     = ""
  description = "cluster_machine_type"
}

variable "cluster_default_max_pods_per_node" {
  type        = number
  default     = 0
  description = "cluster_default_max_pods_per_node"
}

variable "cluster_workload_identity_enabled" {
  type        = bool
  default     = false
  description = "cluster_workload_identity_enabled"
}

variable "cluster_k8s_namespaces" {
  type        = set(string)
  default     = []
  description = "cluster_k8s_namespaces"
}

variable "cluster_istio_config" {
  type        = bool
  default     = false
  description = "cluster_istio_config"
}

variable "cluster_master_authorized_network" {
  type        = string
  default     = ""
  description = "cluster_master_authorized_network"
}

variable "cluster_initial_node_count" {
  type        = number
  default     = 0
  description = "cluster_initial_node_count"
}

variable "cluster_cpu_min" {
  type        = number
  default     = 0
  description = "cluster_cpu_min"
}

variable "cluster_cpu_max" {
  type        = number
  default     = 0
  description = "cluster_cpu_max"
}

variable "cluster_memory_min" {
  type        = number
  default     = 0
  description = "cluster_memory_min"
}

variable "cluster_memory_max" {
  type        = number
  default     = 0
  description = "cluster_memory_max"
}

variable "cluster_min_node_count" {
  type        = number
  default     = 0
  description = "cluster_min_node_count"
}

variable "cluster_max_node_count" {
  type        = number
  default     = 0
  description = "cluster_max_node_count"
}

variable "helm_enabled" {
  type        = bool
  default     = false
  description = "helm_enabled"
}

variable "helm_repository" {
  type        = string
  default     = ""
  description = "helm_repository"
}

variable "helm_chart" {
  type        = string
  default     = ""
  description = "helm_chart"
}

variable "helm_namespace" {
  type        = string
  default     = ""
  description = "helm_namespace"
}

variable "bastion_enabled" {
  type        = bool
  default     = false
  description = "bastion_enabled"
}

variable "bastion_gke-1_ip_cidr_range" {
  type        = string
  default     = ""
  description = "description"
}

variable "bastion_gke-2_ip_cidr_range" {
  type        = string
  default     = ""
  description = "bastion_gke-2_ip_cidr_range"
}

variable "bastion_machine_type" {
  type        = string
  default     = ""
  description = "bastion_machine_type"
}

variable "wi_gke-1_set" {
  type = set(map(string))
  default = [{
    name                = ""
    namespace           = ""
    roles               = ""
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = ""
  }]
  description = "The set of objects with all variables that should be set for WI processing"
}

variable "wi_gke-2_set" {
  type = set(map(string))
  default = [{
    name                = ""
    namespace           = ""
    roles               = ""
    use_existing_k8s_sa = "false"
    annotate_k8s_sa     = "false"
    k8s_sa_name         = ""
  }]
  description = "The set of objects with all variables that should be set for WI processing"
}

variable "lb_exposed_port" {
  type        = number
  default     = null
  description = "The port should be exposed"
}

variable "lb_neg_name" {
  type        = string
  default     = ""
  description = "lb_neg_name"
}

variable "k8s_enabled" {
  type        = bool
  default     = false
  description = "k8s_enabled"
}

variable "lb_enabled" {
  type        = bool
  default     = false
  description = "lb_enabled"
}

variable "mcs_enabled" {
  type        = bool
  default     = false
  description = "mcs_enabled"
}

variable "cluster_gke-1_node_locations" {
  type        = set(string)
  default     = []
  description = "cluster_gke-1_node_locations"
}

variable "cluster_gke-2_node_locations" {
  type        = set(string)
  default     = []
  description = "cluster_gke-2_node_locations"
}

variable "lb_service_name" {
  type        = string
  default     = ""
  description = "service_name"
}

variable "k8s_svc_instance" {
  type        = string
  default     = ""
  description = "k8s_svc_instance"
}

variable "k8s_svc_enabled" {
  type        = string
  default     = ""
  description = "k8s_svc_enabled"
}

variable "k8s_gke-1_svc_namespaces" {
  type        = set(string)
  default     = []
  description = "k8s_gke-1_svc_namespaces"
}

variable "k8s_gke-2_svc_namespaces" {
  type        = set(string)
  default     = []
  description = "k8s_gke-2_svc_namespaces"
}