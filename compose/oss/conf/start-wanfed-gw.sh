#!/bin/bash

set -e
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
retryJoinVar=$2
wanAddressPort=$3
lanAddressPort=$4

sleep 5
# consul agent \
#   -bind '{{ GetInterfaceIP "eth0" }}' \
#   -config-file="$agentConfigVar" \
#   -retry-join="$retryJoinVar" &

# delve debug
/root/go/bin/dlv exec /usr/local/bin/consul \
  --continue \
  --accept-multiclient \
  --headless \
  --listen=:2346 \
  --api-version=2 \
  --log \
  -- agent \
    -bind '{{ GetInterfaceIP "eth0" }}' \
    -config-file="$agentConfigVar" \
    -retry-join="$retryJoinVar" &

sleep 10

consul connect envoy \
  -admin-bind=0.0.0.0:19000 \
  -mesh-gateway \
  -register \
  -address "$lanAddressPort" \
  -wan-address="$wanAddressPort" \
  -expose-servers

# consul connect envoy -gateway=mesh -register \
#                      -expose-servers \
#                      -service "gateway-primary" \
#                      -address "<private address>:8443" \
#                      -wan-address "<externally accessible address>:8443"\
#                      -token=<token for the primary dc gateway>