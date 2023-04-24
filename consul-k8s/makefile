# Variables
CHART_DIR = ~/dev/consul-k8s/charts/consul
LICENSE_FILE = ../secrets/consul_license.txt
KUBERNETES_VERSION = v1.26.3

oss-setup:
	./build-update-values.sh oss

enterprise-setup:
	./build-update-values.sh enterprise
load-secret:
	secret=$(shell cat $(LICENSE_FILE)); \
	kubectl create secret generic consul-ent-license --from-literal="key=$$secret"

oss:
	helm install consul -f values-oss.yaml $(CHART_DIR)

enterprise: enterprise-setup load-secret
	helm install consul -f values-enterprise.yaml $(CHART_DIR)

oss-no-build:
	helm install consul -f values-oss.yaml $(CHART_DIR)

enterprise-no-build: load-secret
	helm install consul -f values-enterprise.yaml $(CHART_DIR)

cleanup:
	helm del --debug consul; kubectl delete pvc -l release=consul; \
    kubectl delete secret consul-ent-license

create-cluster:
	kind create cluster --image kindest/node:$(KUBERNETES_VERSION) --name=dc1

delete-cluster:
	kind delete cluster --name=dc1

.PHONY: oss-setup enterprise-setup load-secret oss enterprise oss-no-build enterprise-no-build cleanup