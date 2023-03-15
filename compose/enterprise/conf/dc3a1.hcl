// Client Config
datacenter = "dc3"
node_name = "dc3a1"
server = false
log_level = "INFO"
data_dir = "/consul-data"

ports {
	dns = 8600
	http = 8500
	grpc = 8502
	//grpc_tls = 8503
	serf_lan = 8301
	serf_wan = 8302
	server = 8300
}
