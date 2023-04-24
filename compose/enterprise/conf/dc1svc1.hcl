// Service Config
service {
  name = "svc1" // This is a group name for a type of service
  port = 9001
  id = "dc1-svc1"

  connect {
    sidecar_service {
      proxy {
        // outbound
        // Creates two listening ports, 5000 and 5001
        // routes to corresponding names
        upstreams = [
          {
            destination_name = "svc1"
            destination_peer = "peer-dc2"
            local_bind_port  = 5000
          },
          {
            destination_name = "svc1"
            local_bind_port  = 5001
          }
        ]
      }
    }
  }

  // Array of health checks for the service
  // This provides a health check endpoint which will be reached via a GET
  // verb every 10s
  check {
    id       = "svc1-check"
    http     = "http://127.0.0.1:9001/health"
    method   = "GET"
    interval = "10s"
    timeout  = "1s"
  }
}

