kind = "service-resolver"
name = "svc1" // alias of the service we redefine behavior for
failover = {
  "*" = {
    sameness_group = "sg1"
  }
}