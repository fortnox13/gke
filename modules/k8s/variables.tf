variable "namespaces" {
  type        = set(string)
  default     = []
  description = "namespaces"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster_name"
}

variable "helm_namespace" {
  type        = string
  default     = ""
  description = "helm_namespace"
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

variable "svc_instance" {
  type        = string
  default     = ""
  description = "svc_instance"
}

variable "svc_enabled" {
  type        = bool
  default     = false
  description = "svc_enabled"
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

variable "svc_namespaces" {
  type        = set(string)
  default     = []
  description = "svc_namespaces"
}