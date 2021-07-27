# data "template_file" "dashboard_cluster" {
#   template = "${file("./dashboards/dashboard_cluster.tpl")}"
#   vars = {
#       cluster_name = "${var.cluster_name}"
#   }
# }

#  output "rendered" {
#    value = "${data.template_file.dashboard_cluster.rendered}"
#  }

# resource "google_monitoring_dashboard" "infrastructure" {
#   dashboard_json = var.template ?  file("${data.template_file.dashboard_cluster.rendered}") : file("${var.dashboard}")
# }

resource "google_monitoring_dashboard" "infrastructure" {
  dashboard_json = var.template ?  templatefile("./dashboards/dashboard_cluster.tpl", { cluster_name = "${var.cluster}" }) : file("${var.dashboard}")
}