#!/bin/bash
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 BASE_NAME DOCKER_REPO"
    exit 1
fi

# Assign the arguments to variables
BASE_NAME=$1
DOCKER_REPO=$2

docker manifest create \
"$DOCKER_REPO"/"$BASE_NAME" \
--amend "$DOCKER_REPO"/"$BASE_NAME"-amd64 \
--amend "$DOCKER_REPO"/"$BASE_NAME"-arm64

# eg. wilko1989/consul-k8s:01-18-2023-compat-1.13
docker manifest push -p "$DOCKER_REPO"/"$BASE_NAME"