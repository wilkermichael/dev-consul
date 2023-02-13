set -e

CONSUL_HTTP_ADDR=localhost:8500 consul peering generate-token -name peer-dc2 -server-external-addresses=10.10.10.1:8503 > token
CONSUL_HTTP_ADDR=localhost:9500 consul peering establish -name peer-dc1 -peering-token "$(cat token)"
