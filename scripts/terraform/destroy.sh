#!/usr/bin/env bash
TF_PLAN_ERROR="Terraform plan failure, STDOUT from command is above"
TFVARS_PATH="${PWD}/tf/.generated/variables.tfvars"

source ./scripts/functions.sh
source ./scripts/terraform/common.sh

destroy_resources() {
  TF_VAR_ENVIRONMENT=$1 terraform destroy -var-file=$TFVARS_PATH
}

plan_destroy() {
  TF_VAR_ENVIRONMENT=$1 terraform plan -destroy -var-file=$TFVARS_PATH -detailed-exitcode

  case "$?" in
    1)
        exit_on_error 1 "${TF_PLAN_ERROR}"
        ;;
  esac
}

handle_terraform() {
  prep_terraform $3
  terraform_init
  plan_destroy $2
  destroy_resources $2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --access=*)
      ACCESS_KEY="${1#*=}"
      ;;
    --bucket=*)
      TF_BUCKET="${1#*=}"
      ;;
    --env=*)
      ENVIRONMENT="${1#*=}"
      ;;
    --region=*)
      REGION="${1#*=}"
      ;;
    --secret=*)
      SECRET_KEY="${1#*=}"
      ;;
    --refresh)
      REFRESH=true
      ;;
    *)
      exit_on_error 1 "${BAD_PARAM_ERROR}"
  esac
  shift
done

handle_terraform \
  "${TF_BUCKET}" \
  "${ENVIRONMENT}" \
  "${REGION}" \
  "${ACCESS_KEY}" \
  "${SECRET_KEY}" \
  "${REFRESH}"
