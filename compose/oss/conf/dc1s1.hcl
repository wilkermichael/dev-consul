// Server Config
datacenter = "dc1"
node_name = "dc1s1"
server = true
log_level = "INFO"
data_dir = "/conf/data/dc1s1"

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

// Configuration entries can be created to provide cluster-wide defaults for various aspects of Consul.
config_entries {

  // The proxy-defaults configuration entry (ProxyDefaults on Kubernetes) allows
  // you to configure global defaults across all services for Connect proxy configurations.
  // Only one global entry is supported.
  // This sets the default protocol for the proxy to use http
  // Envoy uses TCP by default -> envoy can see error 500s
  bootstrap {
    kind = "proxy-defaults"
    name = "global"
    config {
      protocol = "http"
    }
  }

  // exported-services allows for exporting services to other clusters
  // This exports svc1 to the cluster with peering connection named peer-dc1
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

  // service-resolver controls which service instances should satisfy Connect
  // upstream discovery requests for a given service name.
  // This defines the failover of svc1 to svc1 on peer-dc2
  bootstrap {
    kind = "service-resolver"
    name = "svc1" // alias of the service we redefine behavior for

    // This occurs after the default failovers which will select from
    // services matching svc1 in the local cluster
    // id=svc 1/id=svc 2 50/50
    // id=svc1 goes downs -> id=svc2 100% of traffic
    // id=svc2 goes down -> svc1-peer-dc2 gets traffic

    // id=svc1 goes down -> svc1-peer-dc2 get all the traffic
    failover = {
      "*" = {
        targets = [{
          service="svc1"
          peer = "peer-dc2"
        }]
      }
    }
  }
}

// XXX
bootstrap_expect = 1
primary_datacenter = "dc1"
//serf_wan = "10.10.10.1"
//advertise_addr_wan = "10.10.10.1"
//translate_wan_addrs = true
//bind_addr = "10.1.10.1"
bind_addr = "0.0.0.0"
advertise_addr = "10.1.10.1"

connect {
  enabled = true
  enable_mesh_gateway_wan_federation = true
}

# symmetric gossip encryption key
encrypt = "78wscxN/AOgTltBXdAsKsBLuKqS0FIErDnElfvLSink="

tls {
  defaults {
    ca_file = "/conf/certs/consul-agent-ca.pem"
    cert_file = "/conf/certs/dc1-server-consul-0.pem"
    key_file = "/conf/certs/dc1-server-consul-0-key.pem"
  }
}

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

ui_config {
  enabled = true
}

// $ consul acl bootstrap
// AccessorID:       745af7f4-ea98-c376-9d86-9bbb772aeaed
// SecretID:         19165fdf-16db-c283-dec2-40c5942f0319
// Description:      Bootstrap Token (Global Management)
// Local:            false
// Create Time:      2023-02-15 22:17:48.75134217 +0000 UTC
// Policies:
//    00000000-0000-0000-0000-000000000001 - global-management


// # consul acl token create -description "dc1s1 agent token" -node-identity "dc1s1:dc1"
// AccessorID:       23e3fc83-90c4-47d3-1c4e-7fb7e5fb0760
// SecretID:         b41ee9f0-c0b2-27a4-7a98-d05882d03d69
// Description:      dc1s1 agent token
// Local:            false
// Create Time:      2023-02-15 23:52:29.743328467 +0000 UTC
// Node Identities:
//    dc1s1 (Datacenter: dc1)

// $ consul acl token create -description "dc1s1 agent token" \
//   -node-identity "dc1s1:dc1"
// AccessorID:       a52da2d9-6a4c-9e3d-7182-a45fd2cc8afe
// SecretID:         1d0b566d-8817-b2b4-0fca-9b29ceb1d5e7
// Description:      dc1s1 agent token
// Local:            false
// Create Time:      2023-02-15 22:24:04.447455553 +0000 UTC
// Node Identities:
//    dc1s1 (Datacenter: dc1)