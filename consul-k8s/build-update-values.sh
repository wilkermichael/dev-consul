#!/bin/bash

# Run the build-and-push.sh script
cd image/ || exit
./build-and-push.sh -p

# Get the sha's of the images
CONSUL_SHA=$(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul:latest)
CONSUL_K8S_SHA=$(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-k8s-control-plane-dev:latest)

echo "Consul_SHA: $CONSUL_SHA"
echo "CONSUL_K8S_SHA: $CONSUL_K8S_SHA"

# Update the values.yaml file with the new sha's
yq e -i ".global.image = \"$CONSUL_SHA\"" ../values.yaml
yq e -i ".global.imageK8S = \"$CONSUL_K8S_SHA\""  ../values.yaml