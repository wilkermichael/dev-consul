#!/bin/bash

set -e
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
retryJoinVar=$2

sleep 5

consul agent \
  -bind '{{ GetInterfaceIP "eth0" }}' \
  -config-file="$agentConfigVar" \
  -retry-join="$retryJoinVar" &

# delve debug
# /root/go/bin/dlv exec /usr/local/bin/consul \
#   --continue \
#   --accept-multiclient \
#   --headless \
#   --listen=:2346 \
#   --api-version=2 \
#   --log \
#   -- agent \
#     -bind '{{ GetInterfaceIP "eth0" }}' \
#     -config-file="$agentConfigVar" \
#     -retry-join="$retryJoinVar" &

sleep 10

consul config write /conf/proxyconf.hcl
consul config write /conf/ingress.hcl

consul connect envoy \
  -gateway ingress \
  -register \
  -service public-ingress \
  -http-addr=localhost:8500

