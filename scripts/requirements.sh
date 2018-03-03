#!/usr/bin/env bash

commands=(kube-aws)
for i in "${commands[@]}"
do
  if ! [ -x "$(command -v $i)" ]; then
    echo "Error: $i is not installed. Run grunt install via CLI to correct issue." >&2
    exit 1
  fi
done
