#!/bin/bash
set -e

# Check if the correct number of arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 BASE_NAME REPO_NAME VERSION"
    exit 1
fi

# Assign the arguments to variables
BASE_NAME=$1
REPO_NAME=$2
VERSION=$3

# Create a temporary Docker container
docker create --name temp_container --platform=linux/arm64 "$REPO_NAME"/"$BASE_NAME"

# Copy the binary out of the Docker container
docker cp temp_container:/bin/consul-k8s .

# Run the file command on the binary
file_output=$(file consul-k8s)
if echo "$file_output" | grep -q "ARM aarch64"; then
  echo "Success: Binary is built for arm64"
else
  echo "Failure: Binary is not built for arm64"
fi

# Run the version command in a Docker container and remove the container
version_output=$(docker run --rm --platform=linux/arm64 "$REPO_NAME"/"$BASE_NAME" bin/consul-k8s version)

# Check the version of the binary
if echo "$version_output" | grep -q "$VERSION"; then
  echo "Success: Binary version is $VERSION"
else
  echo "Failure: Binary version is not $VERSION version is $version_output"
fi

# Remove the temporary Docker container
docker rm temp_container

# Create a temporary Docker container
docker create --name temp_container --platform=linux/amd64 "$REPO_NAME"/"$BASE_NAME"

# Copy the binary out of the Docker container
docker cp temp_container:/bin/consul-k8s .

# Run the file command on the binary
file_output=$(file consul-k8s)
if echo "$file_output" | grep -q "x86-64"; then
  echo "Success: Binary is built for amd64"
else
  echo "Failure: Binary is not built for amd64"
fi

# Run the version command in a Docker container and remove the container
version_output=$(docker run --rm --platform=linux/arm64 "$REPO_NAME"/"$BASE_NAME" bin/consul-k8s version)

# Check the version of the binary
if echo "$version_output" | grep -q "$VERSION"; then
  echo "Success: Binary version is $VERSION"
else
  echo "Failure: Binary version is not $VERSION version is $version_output"
fi

# Remove the temporary Docker container
docker rm temp_container