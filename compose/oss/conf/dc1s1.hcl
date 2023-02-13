// Server Config
datacenter = "dc1"
node_name = "dc1s1"
server = true
log_level = "INFO"
data_dir = "/consul-data"

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
