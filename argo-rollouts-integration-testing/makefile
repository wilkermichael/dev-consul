
KUBERNETES_VERSION = v1.25.11
CHART_VERSION = 1.3.1
LICENSE_FILE = ../secrets/consul_license.txt
ARGO_REPO=~/dev/argo-rollouts-michael
ARGO_MANIFEST=~/dev/argo-rollouts-michael/manifests/install.yaml
ARGO_DOCKER=wilko1989/argo-rollouts:latest
PLUGIN_DIR=~/dev/rollouts-plugin-trafficrouter-consul

# setup sets up the kind cluster, loads the consul license secret and deploys the consul helm chart
setup: kind load-secret deploy

kind: kind-delete
	kind create cluster --image kindest/node:$(KUBERNETES_VERSION) --name=dc1 --config ./rollout-plugin-resources/kind_config.yaml

add-helm-Repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com

# load-secret loads the consul license secret into the kind cluster
load-secret:
	secret=$(shell cat $(LICENSE_FILE)); \
	kubectl create secret generic consul-ent-license --from-literal="key=$$secret"

# kind-delete deletes the kind cluster dc1
kind-delete:
	kind delete cluster --name=dc1

# deploy deploys the consul helm chart with the values.yaml file
deploy:
	helm install consul hashicorp/consul --version $(CHART_VERSION) -f values.yaml

# Apply a standard setup that can be used as a baseline for service splitting
apply-standard:
	kubectl apply -f resources/proxy-defaults.yaml; sleep 1;\
	kubectl apply -f resources/serviceaccount.yaml; sleep 1;\
	kubectl apply -f resources/service.yaml; \
	kubectl apply -f resources/deployment_v1.yaml; sleep 1;\
	kubectl apply -f resources/deployment_v2.yaml; sleep 1;\
	kubectl apply -f resources/serviceaccount_client.yaml; sleep 1;\
	kubectl apply -f resources/service_client.yaml; \
	kubectl apply -f resources/deployment_client.yaml; sleep 1;\
	kubectl apply -f resources/service-resolver.yaml; sleep 1;\
	kubectl apply -f resources/service-splitter.yaml

# Command for checking how the service is being split by running curl from inside a client pod
check-splitting:
	./scripts/test.sh

# ARGO TESTING MAKE TARGETS

# Install argo rollouts kube extension
install-required-extensions:
	brew install argoproj/tap/kubectl-argo-rollouts; \
	brew install yq

# Build the argo image and copy over the install.yaml manifest file. Automatically updates the yaml with the latest built sha
build-argo:
	./scripts/argobuild.sh $(ARGO_REPO) $(ARGO_DOCKER) $(ARGO_MANIFEST)

# Deploy the argo-rollouts controller
deploy-argo:
	kubectl create namespace argo-rollouts; \
	kubectl apply -n argo-rollouts -f install.yaml

# apply all the Consul and Argo resources needed for testing
apply-crds-argo-testing:
	kubectl apply -f rollout-resources/proxy-defaults.yaml \
	-f rollout-resources/serviceaccount.yaml \
	-f rollout-resources/service.yaml \
	-f rollout-resources/serviceaccount_client.yaml \
	-f rollout-resources/service_client.yaml \
	-f rollout-resources/deployment_client.yaml \
	-f rollout-resources/service-resolver.yaml \
	-f rollout-resources/service-splitter.yaml \
	-f rollout-resources/canary-rollout.yaml

argo: build-argo deploy-argo apply-crds-argo-testing

## CANARY TESTING
# Command used to deploy the canary deployment, will need to be promoted to continue
rollout-watch:
	kubectl argo rollouts get rollout static-server --watch

# Command used to deploy the canary deployment, will need to be promoted to continue
deploy-canary-1:
	kubectl apply -f rollout-resources/canary_rollout_v2.yaml

# Command used to deploy the canary deployment, will need to be promoted to continue
deploy-canary-2:
	kubectl apply -f rollout-resources/canary_rollout_v2.yaml

# Command used to promote the canary deployment stopped with pause{}
promote:
	kubectl argo rollouts promote static-server

## PLUGINS
deploy-argo-plugin:
	kubectl create namespace argo-rollouts; \
	kubectl apply -n argo-rollouts -f rollout-plugin-resources/install.yaml
	kubectl apply -f $(PLUGIN_DIR)/yaml/rbac.yaml

apply-crds-argo-plugin-testing:
	kubectl apply -f rollout-plugin-resources/proxy-defaults.yaml \
	-f rollout-plugin-resources/serviceaccount.yaml \
	-f rollout-plugin-resources/service.yaml \
	-f rollout-plugin-resources/serviceaccount_client.yaml \
	-f rollout-plugin-resources/service_client.yaml \
	-f rollout-plugin-resources/deployment_client.yaml \
	-f rollout-plugin-resources/service-resolver.yaml \
	-f rollout-plugin-resources/service-splitter.yaml \
	-f rollout-plugin-resources/canary-rollout.yaml

argo-plugin: deploy-argo-plugin apply-crds-argo-plugin-testing


deploy-canary-plugin-1:
	kubectl apply -f rollout-plugin-resources/canary_rollout_v2.yaml

# Command used to deploy the canary deployment, will need to be promoted to continue
deploy-canary-plugin-2:
	kubectl apply -f rollout-plugin-resources/canary_rollout_v2.yaml
