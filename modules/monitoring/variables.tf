variable "template" {
  type        = bool
  default     = false
  description = "dashboards_from_template_enabled"
}

variable "dashboard"{
    type = string
    default = ""
    description = "path to JSON file which describe monitoring dashboard"
}


variable "cluster_name" {
  type        = string
  default     = ""
  description = "cluster_name"
}