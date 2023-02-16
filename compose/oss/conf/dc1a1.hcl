// Client Config
datacenter = "dc1"
node_name = "dc1a1"
server = false
log_level = "INFO"
data_dir = "/conf/data/dc1a1"

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

tls {
  defaults {
    ca_file = "/conf/certs/consul-agent-ca.pem"
  }
}

auto_encrypt {
  tls = true
}

acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true
  tokens {
	//agent = "bff6044f-4ade-7916-bdc6-305380f98776"
	
	// init mgmt token from dc1s1
	default = "19165fdf-16db-c283-dec2-40c5942f0319"
	agent = "19165fdf-16db-c283-dec2-40c5942f0319"
  }
}

// # consul acl token create -description "dc1a1 agent token"   -node-identity "dc1a1:dc1"
// AccessorID:       25eeffe5-e212-d362-24d8-e13bbdfb5712
// SecretID:         bff6044f-4ade-7916-bdc6-305380f98776
// Description:      dc1a1 agent token
// Local:            false
// Create Time:      2023-02-15 22:27:21.98520938 +0000 UTC
// Node Identities:
//    dc1a1 (Datacenter: dc1)
