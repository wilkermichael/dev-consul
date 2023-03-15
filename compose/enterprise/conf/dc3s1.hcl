// Server Config
datacenter = "dc3"
node_name = "dc3s1"
server = true
log_level = "INFO"

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
      {
        name = "svc1"
        namespace = "ns2"
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
