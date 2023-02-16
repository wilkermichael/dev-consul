// Client Config
datacenter = "dc1"
node_name = "dc1a2"
server = false
log_level = "INFO"
data_dir = "/conf/data/dc1a2"

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	//grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}

// XXX
primary_datacenter = "dc1"

# symmetric gossip encryption key
encrypt = "78wscxN/AOgTltBXdAsKsBLuKqS0FIErDnElfvLSink="

ca_file = "/conf/certs/consul-agent-ca.pem"

auto_encrypt {
  tls = true
}

acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
  tokens {
	//agent = "7af4327b-1689-2d40-d717-c7bc2108f13e"
	// init mgmt token from dc1s1
	default = "19165fdf-16db-c283-dec2-40c5942f0319"
	agent = "19165fdf-16db-c283-dec2-40c5942f0319"

  }
}

// # consul acl token create -description "dc1a2 agent token"   -node-identity "dc1a2:dc1"
// AccessorID:       a87220b9-57de-881b-4702-dc4e6dac8a65
// SecretID:         7af4327b-1689-2d40-d717-c7bc2108f13e
// Description:      dc1a2 agent token
// Local:            false
// Create Time:      2023-02-15 22:28:19.818402671 +0000 UTC
// Node Identities:
//    dc1a2 (Datacenter: dc1)