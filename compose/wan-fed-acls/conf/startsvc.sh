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

sleep 5
# Setup the partition on the server if required
if [ -n "$partitionVar" ]; then
  echo "Creating partition"
  consul partition create -http-addr="$serverHttpAddrVar" -name "$partitionVar"
else
  partitionVar="default"
fi

# Start the agent
consul agent -bind '{{ GetInterfaceIP "eth1" }}' -config-file="$agentConfigVar" -retry-join="$retryJoinVar" &
sleep 10
forwardsrv 0.0.0.0:9001 "$serviceNameVar" &

# Setup the namespace if required
if [ -n "$namespaceVar" ]; then
  echo "Creating namespace"
  consul namespace create -name "$namespaceVar" -partition "$partitionVar"
else
  namespaceVar="default"
fi

# Log messages for what configuration we're setting up as a whole
if [ -n "$namespaceVar" ] && [ -n "$partitionVar" ]; then
  echo "Configuring with namespace and partition"
elif [ -n "$namespaceVar" ]; then
  echo "Configuring with namespace"
elif [ "$partitionVar" ]; then
  echo "Configuring with partition"
else
  echo "Configuring without namespace or partition"
fi

consul services register -namespace="$namespaceVar" -partition="$partitionVar" "$serviceConfigVar"
consul connect envoy -admin-bind=0.0.0.0:19000 -sidecar-for=svc1 -namespace="$namespaceVar" -partition="$partitionVar"
