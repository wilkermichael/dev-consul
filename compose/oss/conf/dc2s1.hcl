// Server Config
datacenter = "dc2"
node_name = "dc2s1"
server = true
log_level = "INFO"
data_dir = "/conf/data/dc2s1"

client_addr = "0.0.0.0"

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}

config_entries {
  bootstrap {
    kind = "proxy-defaults"
    name = "global"

    config {
      protocol = "http"
    }
  }

  bootstrap {
    kind = "exported-services"
    name = "default"
    services = [
      {
        name = "svc1"
        consumers = [{ peer = "peer-dc1" }]
      },
    ]
  }

  bootstrap {
    kind = "service-resolver"
    name = "svc1"

    failover = {
      "*" = {
        targets = [{peer = "peer-dc1"}]
      }
    }
  }

}

// XXX
bootstrap_expect = 1
primary_datacenter = "dc1"
//serf_wan = "10.10.20.1"
//advertise_addr_wan = "10.10.20.1"
//translate_wan_addrs = true
//bind_addr = "10.2.10.1"
bind_addr = "0.0.0.0"
advertise_addr = "10.2.10.1"

# symmetric gossip encryption key
encrypt = "78wscxN/AOgTltBXdAsKsBLuKqS0FIErDnElfvLSink="

primary_gateways = [ "10.10.10.2:8443"]

connect {
  enabled = true
  enable_mesh_gateway_wan_federation = true
}

ca_file = "/conf/certs/consul-agent-ca.pem"
cert_file = "/conf/certs/dc2-server-consul-0.pem"
key_file = "/conf/certs/dc2-server-consul-0-key.pem"

auto_encrypt {
  allow_tls = true
}

acl = {
  enabled = true
  default_policy = "allow"
  enable_token_persistence = true

  tokens {
    initial_management = "19165fdf-16db-c283-dec2-40c5942f0319"
    agent = "19165fdf-16db-c283-dec2-40c5942f0319"
  }  

}