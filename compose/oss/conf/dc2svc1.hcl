// Service Config
service {
  name = "svc1"
  port = 9001

  connect {
    sidecar_service {
      proxy {
        upstreams = [
          {
            destination_name = "svc1"
            destination_peer = "peer-dc1"
            local_bind_port  = 5000
          }
        ]
      }
    }
  }

  check {
    id       = "svc1-check"
    http     = "http://127.0.0.1:9001/health"
    method   = "GET"
    interval = "10s"
    timeout  = "1s"
  }
}

