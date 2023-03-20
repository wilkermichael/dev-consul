#!/bin/bash

set -e
set -m
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
wanAddressVar=$2

#consul agent -dev -bind=10.1.10.1 -config-file=/conf/dc1s1.hcl &
#consul agent -dev -config-file="$agentConfigVar" &
consul agent -dev -bind '{{ GetInterfaceIP "eth1" }}' -client '{{ GetInterfaceIP "eth0" }}' -config-file="$agentConfigVar" -retry-join-wan="$wanAddressVar" &
sleep 5
consul acl set-agent-token agent "$CONSUL_HTTP_TOKEN"
sleep 5

# Bring Consul agent to the foreground
fg %1