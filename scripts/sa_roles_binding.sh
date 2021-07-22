#!/bin/sh

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -sa|--service_account_id)
      SERVICE_ACCOUNT_ID="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--project_id)
      PROJECT_ID="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL[@]}"

IAM_ROLES=(
	"roles/compute.admin"
	"roles/container.admin"
	"roles/dns.admin"
	"roles/iam.serviceAccountAdmin"
	"roles/iam.serviceAccountKeyAdmin"
	"roles/iam.workloadIdentityPoolAdmin"
	"roles/networkmanagement.admin"
	"roles/privateca.admin"
	"roles/storage.objectAdmin"
	"roles/gkehub.admin"
  "roles/gkemulticloud.admin"
  "roles/resourcemanager.projectIamAdmin"
)

for ROLE in "${IAM_ROLES[@]}"
do
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role=${ROLE}
done