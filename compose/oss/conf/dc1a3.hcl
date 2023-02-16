// Client Config
datacenter = "dc1"
node_name = "dc1a3"
server = false
log_level = "INFO"
data_dir = "/conf/data/dc1a3"

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
	//agent = "7461c806-3679-2e42-7c1e-9da49da0be9c"

	// init mgmt token from dc1s1
	default = "19165fdf-16db-c283-dec2-40c5942f0319"
	agent = "19165fdf-16db-c283-dec2-40c5942f0319"
  }
}

// # consul acl token create -description "dc1a3 agent token"   -node-identity "dc1a3:dc1"
// AccessorID:       9e4ab8cf-f05f-8ef4-1137-56b89c5a918a
// SecretID:         7461c806-3679-2e42-7c1e-9da49da0be9c
// Description:      dc1a3 agent token
// Local:            false
// Create Time:      2023-02-15 22:29:35.057597595 +0000 UTC
// Node Identities:
//    dc1a3 (Datacenter: dc1)
