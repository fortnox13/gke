variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "gcp project id"
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

variable "lb_service_name" {
  type        = string
  default     = ""
  description = "lb_service_name"
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

variable "network_endpoint_group" {
  type        = set(string)
  default     = []
  description = "network_endpoint_group"
}

variable "service_name" {
  type        = string
  default     = ""
  description = "service_name"
}

variable "zones" {
  type        = set(string)
  default     = []
  description = "zones"
}

variable "private_key" {
  description = "private_key"
  default     = ""
  type        = string
}

variable "certificate" {
  description = "certificate"
  default     = ""
  type        = string
}