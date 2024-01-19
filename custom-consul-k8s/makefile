# Building
DOCKER_REPO=wilko1989
BASE_NAME=consul-k8s:01-18-2023-compat-1.13
CONSUL_K8S_DIR=~/dev/consul-k8s
VERSION=0.24.0-dev

# amd-image builds the amd image and pushes it to the docker repo `DOCKER_REPO/BASE_NAME-amd64`
amd-image:
	@cd image; ./build.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_K8S_DIR) "amd64"

# arm-image builds the arm image and pushes it to the docker repo `DOCKER_REPO/BASE_NAME-arm64`
arm-image:
	@cd image; ./build.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_K8S_DIR) "arm64"

# combo-image builds the combo image and pushes it to the docker repo `DOCKER_REPO/BASE_NAME`
combo-image:
	@./scripts/combo_image.sh $(BASE_NAME) $(DOCKER_REPO)

# test-arch tests the amd and arm images are the correct architecture and version using the combo image
test-arch:
	@./scripts/test_arch.sh $(BASE_NAME) $(DOCKER_REPO) $(VERSION)

# build-and-verify builds the amd and arm images and tests them
build-and-verify: amd-image arm-image combo-image test-arch

# Testing
CONSUL_IMAGE=hashicorp/consul-enterprise:1.13-ent
LICENSE_FILE = ../secrets/consul_license.txt
KUBERNETES_VERSION = v1.25.11
#CHART_VERSION = 0.49.8 # usage: eg. helm install consul hashicorp/consul --version $(CHART_VERSION) -f values.yaml
CHART_DIR = ~/dev/consul-helm
ACCEPTANCE_TEST_DIR=~/dev/consul-helm/test/acceptance/tests

# update-values-yaml updates the values.yaml file with CONSUL_IMAGE and DOCKER_REPO/BASE_NAME
update-values-yaml:
	@./scripts/update_values_yaml.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_IMAGE)

# kind-create creates a kind cluster with the specified kubernetes version
kind: kind-delete
	kind create cluster --image kindest/node:$(KUBERNETES_VERSION) --name=dc1

# load-secret loads the consul license secret into the kind cluster
load-secret:
	secret=$(shell cat $(LICENSE_FILE)); \
	kubectl create secret generic consul-ent-license --from-literal="key=$$secret"

# deploy deploys the consul helm chart with the values.yaml file
deploy:
	helm install consul -f values.yaml $(CHART_DIR)

# setup sets up the kind cluster, loads the consul license secret and deploys the consul helm chart
setup: kind load-secret deploy

# acceptance-connect-test runs the connect acceptance tests
acceptance-connect-test:
	@cd $(ACCEPTANCE_TEST_DIR); go test ./connect/... -v -p 1 -timeout 2h -failfast -no-cleanup-on-failure -debug-directory=/tmp/debug

# kind-delete deletes the kind cluster dc1
kind-delete:
	kind delete cluster --name=dc1

# add-helm-Repo adds the hashicorp helm repo
add-helm-Repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com

# Upgrade Testing
OLD_CONSUL_IMAGE=hashicorp/consul-enterprise:1.12-ent
OLD_CHART_DIR = ~/dev/consul-helm-old

# deploy-old deploys the consul helm chart with the values_old.yaml file
deploy-old:
	helm install consul -f values_old.yaml $(OLD_CHART_DIR)

# apply-crd applies the servicedefaults.yaml file
apply-crd:
	kubectl apply -f servicedefaults.yaml

# verify-crd verifies the service defaults resource exists in Kubernetes and Consul
verify-crd:
	kubectl exec consul-server-0 -- consul config read -kind service-defaults -name defaults
	@echo "--------------------------------"
	kubectl get crd servicedefaults.consul.hashicorp.com -o yaml
# upgrade upgrades the consul helm chart with the values.yaml file
upgrade:
	helm upgrade consul -f values.yaml $(CHART_DIR)

# rollback rolls back the consul helm chart to the previous Consul version (if following steps should be that deployed with `deploy-old`)
rollback:
	helm rollback consul