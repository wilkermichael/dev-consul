# Variables
CHART_DIR = ~/dev/consul-k8s/charts/consul
LICENSE_FILE = ../secrets/consul_license.txt
KUBERNETES_VERSION = v1.27.2

K8S_DIR=~/dev/consul-k8s
CONSUL_DIR=~/dev/consul-enterprise
CONSUL_CE_DIR=~/dev/consul
#CONSUL_DIR=~/dev/consul
CONSUL_DATAPLANE_DIR=~/dev/consul-dataplane
DOCKERHUB=wilko1989
#CONSUL_K8S_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul-k8s-control-plane:1.3.0-dev
CONSUL_K8S_IMAGE=$(DOCKERHUB)/consul-k8s-control-plane-dev:ci
CONSUL_IMAGE=$(DOCKERHUB)/consul-enterprise:ci
CONSUL_CE_IMAGE=$(DOCKERHUB)/consul:ci
#CONSUL_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul:1.17-dev
CONSUL_DATAPLANE_IMAGE=$(DOCKERHUB)/consul-dataplane:ci
#CONSUL_DATAPLANE_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul-dataplane:1.3-dev
ENTERPRISE_VALUES_YAML= values-enterprise.yaml
VALUES_YAML= values-ce.yaml

build: build-k8s build-consul build-consul-ce build-dataplane pull update-yaml-enterprise
build-test: build-k8s build-consul build-consul-ce build-dataplane pull test-args

versions:
	@echo "Consul image: ${CONSUL_IMAGE}"
	@echo "Consul-k8s image: ${CONSUL_K8S_IMAGE}"
	@echo "Consul dataplane image: ${CONSUL_DATAPLANE_IMAGE}"

test-args:
	@echo "-consul-image $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')"
	@echo "-consul-k8s-image $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')"
	@echo "-consul-dataplane-image $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')"

values-args:
	@echo "image: $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')"
	@echo "imageK8S: $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')"
	@echo "imageConsulDataplane: $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')"

update-yaml-enterprise:
  # Update the values.yaml file with the new sha's
	@CONSUL_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)');yq e -i ".global.image = \"$$CONSUL_SHA\"" ${ENTERPRISE_VALUES_YAML}
	@CONSUL_K8S_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)');yq e -i ".global.imageK8S = \"$$CONSUL_K8S_SHA\""  ${ENTERPRISE_VALUES_YAML}
	@CONSUL_DATAPLANE_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)');yq e -i ".global.imageConsulDataplane = \"$$CONSUL_DATAPLANE_SHA\""  ${ENTERPRISE_VALUES_YAML}

update-yaml:
  # Update the values.yaml file with the new sha's
	@CONSUL_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)');yq e -i ".global.image = \"$$CONSUL_SHA\"" ${VALUES_YAML}
	@CONSUL_K8S_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)');yq e -i ".global.imageK8S = \"$$CONSUL_K8S_SHA\""  ${VALUES_YAML}
	@CONSUL_DATAPLANE_SHA=$$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)');yq e -i ".global.imageConsulDataplane = \"$$CONSUL_DATAPLANE_SHA\""  ${VALUES_YAML}

build-k8s:
	@echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Building consul-k8s image ${CONSUL_K8S_IMAGE}"
	cd $(K8S_DIR) && REMOTE_DEV_IMAGE=${CONSUL_K8S_IMAGE} GOARCH=amd64 make control-plane-dev-docker-multi-arch

build-consul:
	@echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Building consul image ${CONSUL_IMAGE}"
	@cd $(CONSUL_DIR) && REMOTE_DEV_IMAGE=${CONSUL_IMAGE} GOARCH=amd64 make remote-docker

build-consul-ce:
	@echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Building consul image ${CONSUL_CE_IMAGE}"
	@cd $(CONSUL_CE_DIR) && REMOTE_DEV_IMAGE=${CONSUL_CE_IMAGE} GOARCH=amd64 make remote-docker

build-dataplane:
	@echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Building consul-dataplane image ${CONSUL_DATAPLANE_IMAGE}"
	@cd $(CONSUL_DATAPLANE_DIR) && make bin
	@cd $(CONSUL_DATAPLANE_DIR) && mkdir -p dist/linux/amd64 && GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -trimpath -buildvcs=false -ldflags="$(GOLDFLAGS)" -o dist/linux/amd64/consul-dataplane ./cmd/consul-dataplane
	@cd $(CONSUL_DATAPLANE_DIR) && mkdir -p dist/linux/amd64 && GOARCH=arm64 GOOS=linux CGO_ENABLED=0 go build -trimpath -buildvcs=false -ldflags="$(GOLDFLAGS)" -o dist/linux/arm64/consul-dataplane ./cmd/consul-dataplane
	@cd $(CONSUL_DATAPLANE_DIR) && docker buildx build -t "${CONSUL_DATAPLANE_IMAGE}" --platform linux/amd64,linux/arm64 --push .

pull:
	@docker pull ${CONSUL_K8S_IMAGE}
	@docker pull ${CONSUL_IMAGE}
	@docker pull ${CONSUL_DATAPLANE_IMAGE}

load:
	@kind load docker-image -n dc1 ${CONSUL_K8S_IMAGE} || true
	@kind load docker-image -n dc1 ${CONSUL_IMAGE} || true
	@kind load docker-image -n dc1  ${CONSUL_DATAPLANE_IMAGE} || true
	@kind load docker-image -n dc2 ${CONSUL_K8S_IMAGE} || true
	@kind load docker-image -n dc2 ${CONSUL_IMAGE} || true
	@kind load docker-image -n dc2  ${CONSUL_DATAPLANE_IMAGE} || true

load-secret:
	secret=$(shell cat $(LICENSE_FILE)); \
	kubectl create secret generic consul-ent-license --from-literal="key=$$secret"

deploy-ce: build
	helm install consul -f values-ce.yaml $(CHART_DIR)

deploy-enterprise: build-enterprise load-secret
	helm install consul -f values-enterprise.yaml $(CHART_DIR)

deploy-ce-no-build:
	helm install consul -f values-ce.yaml $(CHART_DIR)

deploy-enterprise-no-build: load-secret
	helm install consul -f values-enterprise.yaml $(CHART_DIR)

cleanup:
	helm del --debug consul; kubectl delete pvc -l release=consul; \
	kubectl delete secret consul-ent-license

kind: kind-delete
	kind create cluster --image kindest/node:$(KUBERNETES_VERSION) --name=dc1

kind-delete:
	kind delete cluster --name=dc1

.PHONY: ce-setup enterprise-setup load-secret ce enterprise ce-no-build enterprise-no-build cleanup