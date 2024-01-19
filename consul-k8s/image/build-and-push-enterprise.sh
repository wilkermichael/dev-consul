#!/bin/bash

consuldir=~/dev/consul-enterprise
consulK8sdir=~/dev/consul-k8s
consulDataplaneDir=~/dev/consul-dataplane

DOCKERHUB=wilko1989
CONSUL_K8S_IMAGE=$(DOCKERHUB)/consul-k8s-control-plane-dev:latest
CONSUL_IMAGE=$(DOCKERHUB)/consul-dev:latest
CONSUL_DATAPLANE_IMAGE=$(DOCKERHUB)/consul-dataplane:latest

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


# Build the docker images
make -C $consuldir REMOTE_DEV_IMAGE=${CONSUL_IMAGE} GOARCH=amd64 remote-docker
make -C $consulK8sdir REMOTE_DEV_IMAGE=${CONSUL_K8S_IMAGE} GOARCH=amd64 control-plane-dev-docker-multi-arch

# Build dataplane docker image
# make -C $consulDataplaneDir docker
@cd $(CONSUL_DATAPLANE_DIR) && make bin
@cd $(CONSUL_DATAPLANE_DIR) && mkdir -p dist/linux/amd64 && GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -trimpath -buildvcs=false -ldflags="$(GOLDFLAGS)" -o dist/linux/amd64/consul-dataplane ./cmd/consul-dataplane
@cd $(CONSUL_DATAPLANE_DIR) && mkdir -p dist/linux/amd64 && GOARCH=arm64 GOOS=linux CGO_ENABLED=0 go build -trimpath -buildvcs=false -ldflags="$(GOLDFLAGS)" -o dist/linux/arm64/consul-dataplane ./cmd/consul-dataplane
@cd $(CONSUL_DATAPLANE_DIR) && docker buildx build -t "${CONSUL_DATAPLANE_IMAGE}" --platform linux/amd64,linux/arm64 --push .

# Push and tag the image if the push argument is present
if [ "$push" = true ] ; then

  #docker tag wilko1989/consul-enterprise:latest wilko1989/consul-enterprise:latest
  #docker push wilko1989/consul-enterprise:latest

  #docker tag consul-k8s-control-plane-dev wilko1989/consul-k8s-control-plane-dev:latest
  #docker push wilko1989/consul-k8s-control-plane-dev:latest

  docker tag consul-dataplane/release-default:1.3.0-rc1 wilko1989/consul-dataplane:latest
  docker push wilko1989/consul-dataplane:latest

  echo ""
  echo "Pushed: "
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-enterprise:latest)
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-k8s-control-plane-dev:latest)
  echo $(docker inspect --format='{{index .RepoDigests 0}}' wilko1989/consul-dataplane:latest)
fi