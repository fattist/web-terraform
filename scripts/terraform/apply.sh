#!/usr/bin/env bash
APPLY=false
REFRESH=false
OVERRIDE=false
TF_PLAN_COMPLETE="STDOUT contains plan instructions for Terraform. To apply changes, re-run command with --apply"
TF_PLAN_ERROR="Terraform plan failure, STDOUT from command is above"
TFVARS_PATH="${PWD}/tf/.generated/variables.tfvars"
BAD_PARAM_ERROR="Invalid arguments: usage $BASH_SOURCE --env=production OR staging"

source ./scripts/functions.sh
source ./scripts/terraform/common.sh

initial_setup() {
  prompt_to_continue "Did you create the bucket: $1 before starting this script? Terraform needs it."
}

apply_resources() {
  echo $TFVARS_PATH
  local CMD="TF_VAR_ENVIRONMENT=$1 terraform apply -var-file=$TFVARS_PATH"

  if [[ ! $OVERRIDE = false ]] ; then
      IFS=',' read -a variables <<< "$OVERRIDE"

      for argument in "${OVERRIDE[@]}"; do
        CMD+=" -var '$argument'"
      done
  fi

  eval $CMD
}

plan_resources() {
  echo $TFVARS_PATH
  local CMD="TF_VAR_ENVIRONMENT=$1 terraform plan -var-file=$TFVARS_PATH -detailed-exitcode"

  if [[ ! $OVERRIDE = false ]] ; then
      IFS=',' read -a variables <<< "$OVERRIDE"

      for argument in "${OVERRIDE[@]}"; do
        CMD+=" -var '$argument'"
      done
  fi

  eval $CMD
  case "$?" in
    1)
        exit_on_error 1 "${TF_PLAN_ERROR}"
        ;;
  esac
}

refresh_resources() {
  TF_VAR_ENVIRONMENT=$1 terraform refresh -var-file=$TFVARS_PATH
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
  local TF_APPLY=$7
  local TF_REFRESH=$6

  # initial_setup $1
  prep_terraform $3
  terraform_init
  plan_resources $2

  if [[ "$TF_APPLY" == true ]]; then
    if [[ "$TF_REFRESH" = true ]]; then
      refresh_resources $2
    else
      apply_resources $2
    fi

    handle_output $2 $3
    cleanup_terraform
  else
    cleanup_terraform
    exit_on_completion 1 "${TF_PLAN_COMPLETE}"
  fi
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
    --override=*)
      OVERRIDE="${1#*=}"
      ;;
    --refresh)
      REFRESH=true
      ;;
    --apply)
      APPLY=true
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
  "${REFRESH}" \
  "${APPLY}"
