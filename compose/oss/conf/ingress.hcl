Kind = "ingress-gateway"
Name = "public-ingress"

TLS {
  Enabled = true
}

Listeners = [
  {
    Port     = 4567
    Protocol = "http"
    Services = [
      {
        Name  = "svc1"
        Hosts = ["svc1.example.com"]
      }
    ]
  }
]