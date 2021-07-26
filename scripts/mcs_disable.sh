#!/bin/sh

GKE_1_name=$1
#GKE_1_zone=$2
GKE_2_name=$2
#GKE_2_zone=$4

#gcloud container hub memberships unregister $GKE_1_name \
#   --gke-cluster $GKE_1_zone/$GKE_1_name
#gcloud container hub memberships unregister $GKE_2_name \
#   --gke-cluster $GKE_2_zone/$GKE_2_name

gcloud container hub memberships $GKE_1_name
gcloud container hub memberships $GKE_2_name