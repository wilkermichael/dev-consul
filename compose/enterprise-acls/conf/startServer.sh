#!/bin/bash

set -e
set -m
trap 'kill $(jobs -p)' EXIT

bindAddress=$1
agentConfigVar=$2

#consul agent -dev -bind=10.1.10.1 -config-file=/conf/dc1s1.hcl &
consul agent -dev -bind="$bindAddress" -config-file="$agentConfigVar" &
sleep 5
consul acl set-agent-token agent "$CONSUL_HTTP_TOKEN"
sleep 5

# Bring Consul agent to the foreground
fg %1