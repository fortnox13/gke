terraform {
  backend "gcs" {
    bucket = "telus-test-01-tf-rs"
    prefix = "state"
  }
}