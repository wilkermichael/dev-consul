#!/bin/bash
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 BASE_NAME DOCKER_REPO CONSUL_IMAGE"
    exit 1
fi

# Assign the arguments to variables
BASE_NAME=$1
DOCKER_REPO=$2
CONSUL_IMAGE=$3

# Assign the argument to a variable
IMAGE="$DOCKER_REPO"/"$BASE_NAME"

# Update the YAML file
yq e ".global.imageK8S = \"$IMAGE\"" -i values.yaml
yq e ".global.image = \"$CONSUL_IMAGE\"" -i values.yaml