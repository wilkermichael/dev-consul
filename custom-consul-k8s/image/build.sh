#!/bin/bash
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 BASE_NAME DOCKER_REPO CONSUL-K8S_DIR ARCH"
    exit 1
fi

# Assign the arguments to variables
BASE_NAME=$1
DOCKER_REPO=$2
CONSUL_K8S_DIR=$3
ARCH=$4

# Buld the binary
CUR_DIR=$(pwd)
cd "$CONSUL_K8S_DIR"
GOOS=linux GOARCH="$ARCH" go build
cd "$CUR_DIR"
# For now this is consul-k8s because it's an older version of Consul-K8s repo, later it will be control-plane so will need to update
cp "$CONSUL_K8S_DIR"/consul-k8s consul-k8s



# Docker build using the date string and purpose as a tag
# eg. wilko1989/consul-k8s:01-18-2023-compat-1.13-amd64
docker build . -t "$DOCKER_REPO"/"$BASE_NAME"-"$ARCH" --platform linux/"$ARCH"

docker tag "$DOCKER_REPO"/"$BASE_NAME"-"$ARCH" "$DOCKER_REPO"/"$BASE_NAME"-"$ARCH"
docker push "$DOCKER_REPO"/"$BASE_NAME"-"$ARCH"