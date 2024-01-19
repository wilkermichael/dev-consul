# Building
DOCKER_REPO=wilko1989
BASE_NAME=consul-k8s:01-18-2023-compat-1.13
CONSUL_K8S_DIR=~/dev/consul-k8s
VERSION=0.24.0-dev

amd-image:
	@cd image; ./build.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_K8S_DIR) "amd64"

arm-image:
	@cd image; ./build.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_K8S_DIR) "arm64"
combo-image:
	@./scripts/combo_image.sh $(BASE_NAME) $(DOCKER_REPO)

test-arch:
	@./scripts/test_arch.sh $(BASE_NAME) $(DOCKER_REPO) $(VERSION)

build-and-verify: amd-image arm-image combo-image test-arch

# Testing
CONSUL_IMAGE=hashicorp/consul-enterprise:1.13-ent
LICENSE_FILE = ../secrets/consul_license.txt
KUBERNETES_VERSION = v1.25.11
#CHART_VERSION = 0.49.8 # usage: eg. helm install consul hashicorp/consul --version $(CHART_VERSION) -f values.yaml
CHART_DIR = ~/dev/consul-helm

update-values-yaml:
	@./scripts/update_values_yaml.sh $(BASE_NAME) $(DOCKER_REPO) $(CONSUL_IMAGE)

kind: kind-delete
	kind create cluster --image kindest/node:$(KUBERNETES_VERSION) --name=dc1

load-secret:
	secret=$(shell cat $(LICENSE_FILE)); \
	kubectl create secret generic consul-ent-license --from-literal="key=$$secret"

deploy:
	helm install consul -f values.yaml $(CHART_DIR)

setup: kind load-secret deploy

acceptance-connect-test:
	@cd ~/dev/consul-helm/test/acceptance/tests; go test ./connect/... -v -p 1 -timeout 2h -failfast -no-cleanup-on-failure -debug-directory=/tmp/debug

kind-delete:
	kind delete cluster --name=dc1

add-helm-Repo:
	helm repo add hashicorp https://helm.releases.hashicorp.com

# Upgrade Testing
OLD_CONSUL_IMAGE=hashicorp/consul-enterprise:1.12-ent
OLD_CHART_DIR = ~/dev/consul-helm-old

## Steps
## 1. Deploy old and wait for it to be ready and successful
## 2. Apply the CRD
## 3. Verify the CRD
## 4. Upgrade the helm chart and wait for it to be ready and successful
## 5. Verify the CRD
## 6. Rollback the helm chart and wait for it to be ready and successful
## 7. Verify the CRD
deploy-old:
	helm install consul -f values_old.yaml $(OLD_CHART_DIR)

apply-crd:
	kubectl apply -f servicedefaults.yaml

verify-crd:
	kubectl exec consul-server-0 -- consul config read -kind service-defaults -name defaults
	@echo "--------------------------------"
	kubectl get crd servicedefaults.consul.hashicorp.com -o yaml
upgrade:
	helm upgrade consul -f values.yaml $(CHART_DIR)

rollback:
	helm rollback consul