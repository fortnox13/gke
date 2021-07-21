terraform {
  backend "gcs" {
    bucket = "telus-bucket-15"
    prefix = "state"
  }
}