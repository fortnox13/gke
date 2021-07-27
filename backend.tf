terraform {
  backend "gcs" {
    bucket = "testing-telus-1"
    prefix = "state"
  }
}