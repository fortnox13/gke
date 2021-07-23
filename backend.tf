terraform {
  backend "gcs" {
    bucket = "testing-21-320709"
    prefix = "state"
  }
}