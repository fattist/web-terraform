#!/usr/bin/env bash

prep_terraform() {
  local DIR="${PWD}/tf"
  local AZ=$1

  rm -rf "${DIR}/.terraform"
  cd "${DIR}"
  cp "${DIR}/zones/${AZ}/terraform.tf" "${DIR}/terraform.tf"
}

cleanup_terraform() {
  rm "${PWD}/terraform.tf"
}

terraform_init() {
  terraform init --backend-config=${PWD}/.generated/backend.tfvars
}
