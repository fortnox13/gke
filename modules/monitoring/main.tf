/*
This module intended for creation dashboards with metrics by using JSON file. 
For creation dashboard with monitoring GKE metrics used template to change filter based on cluster name.  
*/

resource "google_monitoring_dashboard" "infrastructure" {
  dashboard_json = "${var.template}" ?  templatefile("./dashboards/dashboard_cluster.tpl", { cluster_name = var.cluster_name }) : file(var.dashboard)
}
