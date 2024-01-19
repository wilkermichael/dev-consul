# Variables
CHART_DIR = ~/dev/consul-k8s/charts/consul
LICENSE_FILE = ../secrets/consul_license.txt
KUBERNETES_VERSION = v1.27.2

K8S_DIR=~/dev/consul-k8s
CONSUL_DIR=~/dev/consul-enterprise
#CONSUL_DIR=~/dev/consul
CONSUL_DATAPLANE_DIR=~/dev/consul-dataplane
DOCKERHUB=wilko1989
#CONSUL_K8S_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul-k8s-control-plane:1.3.0-dev
CONSUL_K8S_IMAGE=$(DOCKERHUB)/consul-k8s-control-plane-dev:latest
CONSUL_IMAGE=$(DOCKERHUB)/consul-enterprise:latest
#CONSUL_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul:1.17-dev
CONSUL_DATAPLANE_IMAGE=$(DOCKERHUB)/consul-dataplane:latest
#CONSUL_DATAPLANE_IMAGE=docker.mirror.hashicorp.services/hashicorppreview/consul-dataplane:1.3-dev
ENTERPRISE_VALUES_YAML= values-enterprise.yaml
VALUES_YAML= values-ce.yaml

build: build-k8s build-consul build-dataplane pull update-yaml-enterprise
build-test: build-k8s build-consul build-dataplane pull test-args

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

build-dataplane:
	@echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`] Building consul image ${CONSUL_DATAPLANE_IMAGE}"
	@cd $(CONSUL_DATAPLANE_DIR) && REMOTE_DEV_IMAGE=${CONSUL_DATAPLANE_IMAGE} GOARCH=amd64 make dev-docker

pull:
	@docker pull ${CONSUL_K8S_IMAGE}
	@docker pull ${CONSUL_IMAGE}
	@docker pull ${CONSUL_DATAPLANE_IMAGE}

load-latest:
	@kind load docker-image -n dc1 ${CONSUL_K8S_IMAGE}
	@kind load docker-image -n dc1 ${CONSUL_IMAGE}
	@kind load docker-image -n dc1  ${CONSUL_DATAPLANE_IMAGE}
	@kind load docker-image -n dc2 ${CONSUL_K8S_IMAGE}
	@kind load docker-image -n dc2 ${CONSUL_IMAGE}
	@kind load docker-image -n dc2  ${CONSUL_DATAPLANE_IMAGE}
	@kind load docker-image -n dc3 ${CONSUL_K8S_IMAGE}
	@kind load docker-image -n dc3 ${CONSUL_IMAGE}
	@kind load docker-image -n dc3  ${CONSUL_DATAPLANE_IMAGE}
	@kind load docker-image -n dc4 ${CONSUL_K8S_IMAGE}
	@kind load docker-image -n dc4 ${CONSUL_IMAGE}
	@kind load docker-image -n dc4  ${CONSUL_DATAPLANE_IMAGE}

load:
	@kind load docker-image -n dc1 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')
	@kind load docker-image -n dc1 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')
	@kind load docker-image -n dc1 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')
	@kind load docker-image -n dc2 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')
	@kind load docker-image -n dc2 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')
	@kind load docker-image -n dc2 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')
	@kind load docker-image -n dc3 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')
	@kind load docker-image -n dc3 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')
	@kind load docker-image -n dc3 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')
	@kind load docker-image -n dc4 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_K8S_IMAGE)')
	@kind load docker-image -n dc4 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_IMAGE)')
	@kind load docker-image -n dc4 $$(docker inspect --format='{{index .RepoDigests 0}}' '$(CONSUL_DATAPLANE_IMAGE)')

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

load-cni:
	docker pull docker.io/calico/typha:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/typha:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/typha:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/typha:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/typha:v3.24.0
	docker pull docker.io/calico/node:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/node:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/node:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/node:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/node:v3.24.0
	docker pull docker.io/calico/pod2daemon-flexvol:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/pod2daemon-flexvol:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/pod2daemon-flexvol:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/pod2daemon-flexvol:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/pod2daemon-flexvol:v3.24.0
	docker pull docker.io/calico/cni:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/cni:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/cni:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/cni:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/cni:v3.24.0
	docker pull docker.io/calico/node-driver-registrar:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/node-driver-registrar:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/node-driver-registrar:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/node-driver-registrar:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/node-driver-registrar:v3.24.0
	docker pull docker.io/calico/kube-controllers:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/kube-controllers:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/kube-controllers:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/kube-controllers:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/kube-controllers:v3.24.0
	docker pull docker.io/calico/apiserver:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/apiserver:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/apiserver:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/apiserver:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/apiserver:v3.24.0
	docker pull docker.io/calico/csi:v3.24.0
	kind load docker-image --name dc4 docker.io/calico/csi:v3.24.0
	kind load docker-image --name dc3 docker.io/calico/csi:v3.24.0
	kind load docker-image --name dc2 docker.io/calico/csi:v3.24.0
	kind load docker-image --name dc1 docker.io/calico/csi:v3.24.0

.PHONY: ce-setup enterprise-setup load-secret ce enterprise ce-no-build enterprise-no-build cleanup