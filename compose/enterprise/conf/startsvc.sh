#!/bin/bash

set -e
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
retryJoinVar=$2
serviceConfigVar=$3
serviceNameVar=$4

sleep 5
consul agent -bind '{{ GetInterfaceIP "eth0" }}' -config-file="$agentConfigVar" -retry-join="$retryJoinVar" &
sleep 10
forwardsrv 0.0.0.0:9001 "$serviceNameVar" &

consul services register "$serviceConfigVar"
consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1
