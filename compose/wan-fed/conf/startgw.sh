#!/bin/bash

set -e
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
retryJoinVar=$2
wanAddress=$3
lanAddress=$4


sleep 5
consul agent \
 -bind '{{ GetInterfaceIP "eth0" }}' \
 -serf-wan-bind '{{ GetInterfaceIP "eth1" }}' \
 -config-file="$agentConfigVar" \
 -retry-join="$retryJoinVar" &
sleep 10
consul connect envoy \
 -admin-bind=0.0.0.0:19000 \
 -mesh-gateway \
 -register \
 -address "$lanAddress" \
 -wan-address="$wanAddress" \
 -expose-servers
