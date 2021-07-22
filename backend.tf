terraform {
  backend "gcs" {
    bucket = "telus-bucket-17"
    prefix = "state"
  }
}