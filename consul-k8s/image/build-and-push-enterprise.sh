#!/bin/bash

# Set an optional argument for pushing and tagging
# Use -p or --push to enable pushing and tagging
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -p|--push)
    push=true
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

# Set the path to the Consul directory
# consuldir=~/dev/consul
consuldir=~/dev/consul-enterprise
consulK8sdir=~/dev/consul-k8s

# Build the docker images
make -C $consuldir dev-docker
make -C $consulK8sdir control-plane-dev-docker

# Push and tag the image if the push argument is present
if [ "$push" = true ] ; then
  docker tag consul:local wilko1989/consul-enterprise:latest
  docker push wilko1989/consul-enterprise:latest

  docker tag consul-k8s-control-plane-dev wilko1989/consul-k8s-control-plane-dev:latest
  docker push wilko1989/consul-k8s-control-plane-dev:latest
fi