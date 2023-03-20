// Client Config
datacenter = "dc2"
node_name = "dc2a3"
server = false
log_level = "INFO"
data_dir = "/consul-data"
primary_datacenter = "dc1"

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	//grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}

acl = {
	enabled = true
	default_policy = "deny"
	enable_token_persistence = true
}