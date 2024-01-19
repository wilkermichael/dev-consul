#!/bin/bash

set -e
set -m
trap 'kill $(jobs -p)' EXIT

bindAddress=$1
agentConfigVar=$2
partitionVar=$3

#consul agent -dev -bind=10.1.10.1 -config-file=/conf/dc1s1.hcl &
consul agent -dev -bind="$bindAddress" -config-file="$agentConfigVar" &
sleep 5

consul partition create -name "$partitionVar"
sleep 5

consul config write /conf/s1_conf/proxy_defaults_partition.hcl
consul config write /conf/s1_conf/service_defaults_partition.hcl
consul config write /conf/s1_conf/service_resolver.hcl
consul config write /conf/s1_conf/sameness_group_partition.hcl


# Bring Consul agent to the foreground
fg %1