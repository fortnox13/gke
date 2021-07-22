variable "gcp_project_id" {
  type        = string
  default     = ""
  description = "GCP project id"
}

variable "members" {
  description = "List of members in the standard GCP form: user:{email}, serviceAccount:{email}, group:{email}"
  type        = list(string)
}

variable "primary_ip_cidr_range" {
  type        = string
  default     = ""
  description = "primary_ip_cidr_range"
}

variable "gcp_region" {
  type        = string
  default     = ""
  description = "gcp_region"
}

variable "network" {
  type        = string
  default     = ""
  description = "network"
}

variable "machine_type" {
  type        = string
  default     = ""
  description = "machine_type"
}

variable "gcp_zone" {
  type        = string
  default     = ""
  description = "gcp_zone"
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster_name"
}