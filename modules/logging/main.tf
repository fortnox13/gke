/*
This module intended to create logging backups to bucket and bigquery.
 Create NEARLINE bucket with lifecycle configuration to delete files older than 365 days.
  All logs imports to this bucket every hour. 
Create bigquery table which have logs for last 2 hours to have opportunities to see 
logs which do not imported to bucket yet.
*/
// Provides access to available Google Container Engine versions in a zone for a given project.
// Create a Cloud Storage Bucket for long-term storage of logs
// Note: the bucket has force_destroy turned on, so the data will be lost if you run
// terraform destroy
resource "google_storage_bucket" "log-bucket" {
  name          = "stackdriver-logging-bucket-${random_id.server.hex}"
  storage_class = "NEARLINE"
  force_destroy = true
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

}

// Create a BigQuery Dataset for storage of logs
// Note: only the most recent hour's data will be stored based on the table expiration
resource "google_bigquery_dataset" "bigquery-dataset" {
  dataset_id                  = "logs_dataset"
  location                    = "US"
  default_table_expiration_ms = 7200000

  labels = {
    env = "default"
 }
}

///////////////////////////////////////////////////////////////////////////////////////
// Configure the stackdriver sinks and necessary roles.
// To enable writing to the various export sinks we must grant additional permissions.
// Refer to the following URL for details:
// https://cloud.google.com/logging/docs/export/configure_export_v2#dest-auth
///////////////////////////////////////////////////////////////////////////////////////

// Create the Stackdriver Export Sink for Cloud Storage Notifications
resource "google_logging_project_sink" "storage-sink" {
  name        = "storage-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  filter      = "resource.type = k8s_container"

  unique_writer_identity = true
}

// Create the Stackdriver Export Sink for BigQuery Notifications
resource "google_logging_project_sink" "bigquery-sink" {
  name        = "bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.bigquery-dataset.dataset_id}"
  filter      = "resource.type = k8s_container"

  unique_writer_identity = true
}

// Grant the role of Storage Object Creator
resource "google_project_iam_binding" "log-writer-storage" {
  role = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.storage-sink.writer_identity,
  ]
}

// Grant the role of BigQuery Data Editor
resource "google_project_iam_binding" "log-writer-bigquery" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.bigquery-sink.writer_identity,
  ]
}

