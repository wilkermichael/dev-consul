set -e
export CONSUL_HTTP_TOKEN=1307a1a3-e031-6b29-51c3-d3a22fcb1121

CONSUL_HTTP_ADDR=localhost:8500 consul peering generate-token -name peer-dc2 -server-external-addresses=10.10.10.1:8503 > ../../secrets/token
CONSUL_HTTP_ADDR=localhost:9500 consul peering establish -name peer-dc1 -peering-token "$(cat ../../secrets/token)"

CONSUL_HTTP_ADDR=localhost:8500 consul peering generate-token -name peer-dc3 -server-external-addresses=10.10.10.1:8503 > ../../secrets/token-2
CONSUL_HTTP_ADDR=localhost:7500 consul peering establish -name peer-dc1 -peering-token "$(cat ../../secrets/token-2)"