// Server Config
datacenter = "dc2"
primary_datacenter = "dc1"
node_name = "dc2s1"
server = true
log_level = "INFO"
data_dir = "/consul-data"
bootstrap_expect = 1

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}

acl = {
  enabled = true
  default_policy = "deny"
  enable_token_persistence = true

  tokens = {
    initial_management = "1307a1a3-e031-6b29-51c3-d3a22fcb1121"
    agent = "1307a1a3-e031-6b29-51c3-d3a22fcb1121"
    default = "1307a1a3-e031-6b29-51c3-d3a22fcb1121"
    replication = "1307a1a3-e031-6b29-51c3-d3a22fcb1121"
  }
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
