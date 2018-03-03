#!/usr/bin/env bash
MODULE=false
REFRESH=false
RESOURCE=false
TF_PLAN_ERROR="Terraform plan failure, STDOUT from command is above"
TFVARS_PATH="${PWD}/terraform/varfiles/.generated/variables.tfvars"
BAD_PARAM_ERROR="Invalid arguments: usage $BASH_SOURCE --env=production OR staging"

source ./scripts/functions.sh
source ./scripts/terraform/common.sh

initial_setup() {
  prompt_to_continue "Did you create the bucket: $1 before starting this script? Terraform needs it."
}

plan_resources() {
  echo $TFVARS_PATH
  TF_VAR_ENVIRONMENT=$1 terraform plan -var-file=$TFVARS_PATH -detailed-exitcode

  case "$?" in
    1)
        exit_on_error 1 "${TF_PLAN_ERROR}"
        ;;
  esac
}

refresh_resources() {
  TF_VAR_ENVIRONMENT=$1 terraform refresh -var-file=$TFVARS_PATH
}

taint_resources() {
  local ENVIRONMENT=$1
  local MODULE=$2
  local RESOURCE=$3

  if [[ "$RESOURCE" = false ]]; then
    exit_on_error "Terraform taint command requires a module and resource!"
  fi

  TF_VAR_ENVIRONMENT=$ENVIRONMENT terraform taint -module=$MODULE $RESOURCE
}

handle_output() {
  local ENVIRONMENT=$1
  local AZ=$2
  local DIR="${PWD}/output/${AZ}"

  if [[ ! -d  $DIR ]] ; then
    mkdir -p $DIR
  fi

  echo `terraform output -json` > "${DIR}/${ENVIRONMENT}.json"
}

handle_terraform() {
  local TF_REFRESH=$6

  # initial_setup $1
  prep_terraform $3
  terraform_init
  plan_resources $2
  taint_resources $2 $7 $8

  handle_output $2 $3

  if [[ "$TF_REFRESH" = false ]]; then
    refresh_resources $2
  fi

  cleanup_terraform
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
    --module=*)
      MODULE="${1#*=}"
      ;;
    --resource=*)
      RESOURCE="${1#*=}"
      ;;
    *)
      exit_on_error 1 "$1 : ${BAD_PARAM_ERROR}"
  esac
  shift
done

handle_terraform \
  "${TF_BUCKET}" \
  "${ENVIRONMENT}" \
  "${REGION}" \
  "${ACCESS_KEY}" \
  "${SECRET_KEY}" \
  "${REFRESH}" \
  "${MODULE}" \
  "${RESOURCE}"
