#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 ARGO_REPO ARGO_DOCKER INSTALL_YAML_DIR"
    exit 1
fi

# Assign the arguments to variables
ARGO_REPO=$1
ARGO_DOCKER=$2
INSTALL_YAML_DIR=$3

# Run the codegen make target
make -C "$ARGO_REPO" codegen

# Build the Docker image
IMAGE_PREFIX=wilko1989/ DEV_IMAGE=true DOCKER_PUSH=true make -C "$ARGO_REPO" image

# Push the Docker image
docker push "$ARGO_DOCKER"

# Grab the SHA from the Docker build
IMAGE_WITH_SHA=$(docker inspect --format='{{index .RepoDigests 0}}' "$ARGO_DOCKER")

# Copy the install.yaml file from the specified directory
cp "$INSTALL_YAML_DIR" install.yaml

# Update the YAML file
yq e "(select(.kind == \"Deployment\") | .spec.template.spec.containers[0].image) = \"$IMAGE_WITH_SHA\"" -i install.yaml
