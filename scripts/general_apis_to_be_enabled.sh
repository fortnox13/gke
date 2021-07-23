#!/bin/sh

PROJECT_ID=$1

# General APIs:
gcloud services enable compute.googleapis.com --project $PROJECT_ID
gcloud services enable dns.googleapis.com --project $PROJECT_ID
gcloud services enable stackdriver.googleapis.com --project $PROJECT_ID
gcloud services enable cloudresourcemanager.googleapis.com --project $PROJECT_ID
gcloud services enable container.googleapis.com --project $PROJECT_ID
gcloud services enable iap.googleapis.com  --project $PROJECT_ID