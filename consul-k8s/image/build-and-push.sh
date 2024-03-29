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
consuldir=~/dev/consul
consulK8sdir=~/dev/consul-k8s
consulDataplaneDir=~/dev/consul-dataplane

# Build the docker images
make -C $consuldir REMOTE_DEV_IMAGE=wilko1989/consul:latest remote-docker
make -C $consulK8sdir REMOTE_DEV_IMAGE=wilko1989/control-plane:latest control-plane-dev-docker-multi-arch
make -C $consulDataplaneDir docker

# Push and tag the image if the push argument is present
if [ "$push" = true ] ; then
  docker tag hashicorp/consul:latest wilko1989/consul:latest
  docker push wilko1989/consul:latest

#  docker tag consul-k8s-control-plane-dev wilko1989/consul-k8s-control-plane-dev:latest
#  docker push wilko1989/consul-k8s-control-plane-dev:latest

  docker tag consul-dataplane/release-default:1.3.0-dev wilko1989/consul-dataplane:latest
  docker push wilko1989/consul-dataplane:latest

  echo ""
  echo "Pushed: "
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-enterprise:latest)
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-k8s-control-plane-dev:latest)
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-dataplane:latest)
fi