#!/bin/bash

set -e
trap 'kill $(jobs -p)' EXIT

agentConfigVar=$1
retryJoinVar=$2
serviceConfigVar=$3
serviceNameVar=$4
namespaceVar=$5
partitionVar=$6
serverHttpAddrVar=$7

# Setup the partition on the server if required
if [ -n "$partitionVar" ]; then
      echo "Creating partition"
      consul partition create -http-addr="$serverHttpAddrVar" -name "$partitionVar"
fi

# Start the agent
sleep 5
consul agent -bind '{{ GetInterfaceIP "eth0" }}' -config-file="$agentConfigVar" -retry-join="$retryJoinVar" &
sleep 10
forwardsrv 0.0.0.0:9001 "$serviceNameVar" &

if [ -n "$namespaceVar" ] && [ -n "$partitionVar" ]; then
  echo "Configuring with namespace and partition"

  consul namespace create -name "$namespaceVar" -partition "$partitionVar"
  consul services register -namespace="$namespaceVar" -partition="$partitionVar" "$serviceConfigVar"
  consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1 -namespace="$namespaceVar" -partition="$partitionVar"
elif [ -n "$namespaceVar" ]; then
  echo "Configuring with namespace"

  consul namespace create -name "$namespaceVar"
  consul services register -namespace="$namespaceVar" "$serviceConfigVar"
  consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1 -namespace="$namespaceVar"
elif [ "$partitionVar" ]; then
  echo "Configuring with partition"

  consul services register -partition="$partitionVar" "$serviceConfigVar"
  consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1 -partition="$partitionVar"
else
  echo "Configuring without namespace or partition"

  consul services register "$serviceConfigVar"
  consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1
fi
